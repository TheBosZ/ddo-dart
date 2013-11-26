part of ddo;

class DDOMySQL extends Driver {

	DDOConnectionMySQL _connection;

	DDOMySQL(String host, String dbname, String username, String password){
		List<String> h = host.split(':');
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

	Future<DDOResults> exec(String query) {
		Completer completer = new Completer();
		_uQuery(query).then((DDOResults results){
			if(results.insertId != null) {
				_lastInsertId = results.insertId;
			}
			if(results.affectedRows != null) {
				_affectedRows = results.affectedRows;
			}
			completer.complete(results);
		}, onError: (error) => completer.completeError(error));
		return completer.future;
	}

	DDOStatement prepare(String query, [List array = null]) => new DDOStatement(query, _connection, _dbinfo, _containerDdo);

	DDOStatement query(String query) {
		DDOStatement statement = new DDOStatement(
			query, _connection, _dbinfo, _containerDdo
		);
		statement.query();
		return statement;
	}

	// Per http://dev.mysql.com/doc/refman/5.0/en/mysql-real-escape-string.html,
	// only backslash and single quote need to be escaped
	String quote(String value) => "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";

	Future rollBack() => exec("ROLLBACK");

	bool setAttribute(int attr, mixed) {
		// TODO implement this method
	}

	dynamic getAttribute(int attr) {
  		// TODO implement this method
	}

	Future<DDOResults> _uQuery(String query) => _connection.query(query);

}