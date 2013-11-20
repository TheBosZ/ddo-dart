part of ddo;

class DDOMySQL extends Driver {

	ConnectionPool _connection;
	List<String> _dbinfo;
	String _errorCode;
	List<String> _errorInfo;
	int _lastInsertId;

	DDOMySQL(String host, String dbname, String username, String password){
		List<String> h = host.split(':');
		_connection = new ConnectionPool(
			host: h[0],
			port: int.parse(h[1]),
			user: username,
			password: password,
			db: dbname,
			max: 5
		);
		_dbinfo = [host, username, password, dbname];
	}

	Future beginTransaction() {
		return exec("BEGIN");
	}

	bool close() {
		_connection.close();
		return true;
	}

	Future commit() {
	  return exec("COMMIT");
	}

	String errorCode() {
		return _errorCode;
	}

	List<String> errorInfo() {
		return _errorInfo;
	}

	Future exec(String query) {
		return _uQuery(query).then((Results results){
			if(results.insertId != null) {
				_lastInsertId = results.insertId;
			}
			return results.affectedRows;
		});
	}

	int lastInsertId() {
		return _lastInsertId;
	}

	DDOStatement prepare(String query, [List array = null]) {
		return new DDOStatementMySQL(query, _connection, _dbinfo, _containerDdo);
	}

	DDOStatement query(String query) {
		DDOStatementMySQL statement = new DDOStatementMySQL(
			query, _connection, _dbinfo, _containerDdo
		);
		statement.query();
		return statement;
	}

	// Per http://dev.mysql.com/doc/refman/5.0/en/mysql-real-escape-string.html,
	// only backslash and single quote need to be escaped
	String quote(String value) {
		return "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";
	}

	Future rollBack() {
		return exec("ROLLBACK");
	}

	bool setAttribute(int attr, mixed) {
		// TODO implement this method
	}

	dynamic getAttribute(int attr) {
  		// TODO implement this method
	}

	Future<Results> _uQuery(String query) {
		return _connection.query(query);
	}
}