part of ddo;

abstract class Driver {
	DDO containerDdo = null;
	Map<String, String> dbinfo;
	String errorCode;
	List<String> errorInfo;
	int lastInsertId;
	int affectedRows;
	bool logging = false;

	int errorNo;
	String error;
	List<List> results;

	bool throwExceptions = false;
	bool persistent = false;

	//Methods

	//Abstracts
	Future beginTransaction();

	bool close();

	Future rollBack();

	Future commit();

	String quote(String value);

	Object getAttribute(int attr);

	bool setAttribute(int attr, Object mixed);

	Object quoteIdentifier(Object text);

	Future<int> exec(String query) {
		return uQuery(query).then((DDOResults results) {
			if (results.insertId != null) {
				lastInsertId = results.insertId;
			}
			if (results.affectedRows != null) {
				affectedRows = results.affectedRows;
				return affectedRows;
			}
			return -1;
		});
	}

	DDOStatement prepare(String query, [List array = null]) => new DDOStatement(query, this, containerDdo);

	Future<DDOResults> query(String query) {
		return uQuery(query);
	}

	Future<DDOResults> uQuery(String query);

	int getAffectedRows() {
		return affectedRows;
	}

	String applyLimit(String sql, int offset, int limit);
}
