part of ddo;

class DDOSQLite extends Driver {

	DDOSQLite(String host, String dbname, String username, String password) {
    		_connection = new DDOConnectionSQLite();
    		_dbinfo = [host, username, password, dbname];
    	}

	@override
	Future beginTransaction() {
		// TODO: implement beginTransaction
	}

	@override
	bool close() {
		// TODO: implement close
	}

	@override
	Future commit() {
		// TODO: implement commit
	}

	@override
	Future<int> exec(String query) {
		// TODO: implement exec
	}

	@override
	Object getAttribute(int attr) {
		// TODO: implement getAttribute
	}

	@override
	DDOStatement prepare(String query, [List array = null]) {
		// TODO: implement prepare
	}

	@override
	Future<DDOStatement> query(String query) {
		// TODO: implement query
	}

	@override
	String quote(String value) {
		// TODO: implement quote
	}

	@override
	Object quoteIdentifier(Object text) {
		// TODO: implement quoteIdentifier
	}

	@override
	Future rollBack() {
		// TODO: implement rollBack
	}

	@override
	bool setAttribute(int attr, Object mixed) {
		// TODO: implement setAttribute
	}
}
