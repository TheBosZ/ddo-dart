part of dart_ddo;

class DDOMySQL extends Driver {

	bool logging = false;

	DDOConnectionMySQL _connection;
	bool _throwExceptions = false;
	bool _persistent = false;

	DDOMySQL(String host, String dbname, String username, String password){
		List<String> h = host.split(':');
		if(h.length < 2) {
			h.add('3306');
		}
		_connection = new DDOConnectionMySQL(
			host: h[0],
			port: int.parse(h[1]),
			user: username,
			password: password,
			db: dbname
		);
		_dbinfo = [host, username, password, dbname];
	}

	Future beginTransaction() => exec("BEGIN");

	bool close() => _connection.close();

	Future commit() => exec("COMMIT");

	Future<int> exec(String query) {
		Completer completer = new Completer();
		_uQuery(query).then((DDOResults results){
			if(results.affectedRows != null) {
				completer.complete(_affectedRows = results.affectedRows);
			}
			completer.complete(-1);
		}, onError: (error) => completer.completeError(error));
		return completer.future;
	}

	DDOStatement prepare(String query, [List array = null]) => new DDOStatement(query, _connection, _dbinfo, _containerDdo);

	Future<DDOStatement> query(String query) {
		DDOStatement statement = new DDOStatement(
			query, _connection, _dbinfo, _containerDdo
		);
		Completer c = new Completer();
		statement.query().then((_) {
			c.complete(statement);
		});
		return c.future;
	}

	// Per http://dev.mysql.com/doc/refman/5.0/en/mysql-real-escape-string.html,
	// only backslash and single quote need to be escaped
	String quote(String value) => "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";

	Future rollBack() => exec("ROLLBACK");

	bool setAttribute(int attr, Object mixed) {
		bool result = false;
		if(attr == DDO.ATTR_ERRMODE && mixed == DDO.ERRMODE_EXCEPTION) {
			_throwExceptions = true;
		} else if(attr == DDO.ATTR_STATEMENT_CLASS && mixed is List && mixed[0] == 'LoggedDDOStatement') {
			logging = true;
		} else if(attr == DDO.ATTR_PERSISTENT && mixed != _persistent) {
			result = true;
			_persistent = (mixed as bool);
			_connection.close();
			//We should be checking persistent here and opening a persistent connection or not.
			//Right now, persistent connections aren't supported
			List<String> h = _dbinfo[0].split(':');
			_connection = new DDOConnectionMySQL(host: h[0], port: int.parse(h[1]), user: _dbinfo[1], password: _dbinfo[2], db: _dbinfo[3]);

		}
		return result;
	}

	Object getAttribute(int attr) {
  		Object result = false;
  		switch(attr) {
  			case DDO.ATTR_SERVER_INFO:
  				break;
  			case DDO.ATTR_SERVER_VERSION:
  				break;
  			case DDO.ATTR_CLIENT_VERSION:
  				break;
  			case DDO.ATTR_PERSISTENT:
  				result = _persistent;
  				break;
  		}
  		return result;
	}

	Future<DDOResults> _uQuery(String query) => _connection.query(query);

}