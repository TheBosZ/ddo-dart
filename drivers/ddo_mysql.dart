part of ddo;

class DDOMySQL extends Driver {

	ConnectionPool _connection;
	List<String> _dbinfo;
	String _errorCode;
	List<String> _errorInfo;

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
			return results.affectedRows;
		});
	}

	getAttribute(int attr) {
	  // TODO implement this method
	}

	int lastInsertId() {
	  // TODO implement this method
	}

	DDOStatement prepare(String query, [List array = null]) {
	  // TODO implement this method
	}

	DDOStatement query(String query) {
		DDOStatementMySQL statement = new DDOStatementMySQL(
			query, _connection, _dbinfo, _containerDdo
		);
		statement.query();
		return statement;
	}

	String quote(String value) {
	  // TODO implement this method
	}

	Future rollBack() {
	  // TODO implement this method
	}

	bool setAttribute(int attr, mixed) {
	  // TODO implement this method
	}

	Future<Results> _uQuery(String query) {
		return _connection.query(query);
	}
}