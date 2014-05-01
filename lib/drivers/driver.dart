part of ddo;

abstract class Driver {
	DDO containerDdo = null;
	List<String> dbinfo;
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
		Completer completer = new Completer();
		uQuery(query).then((DDOResults results) {
			if (results.insertId != null) {
				lastInsertId = results.insertId;
			}
			if (results.affectedRows != null) {
				completer.complete(affectedRows = results.affectedRows);
			}
			completer.complete(-1);
		}, onError: (error) => completer.completeError(error));
		return completer.future;
	}

	DDOStatement prepare(String query, [List array = null]) => new DDOStatement(query, this, containerDdo);

	Future<DDOResults> query(String query) {
		return uQuery(query);
	}

	Future<DDOResults> uQuery(String query);

	int getAffectedRows() {
		return affectedRows;
	}
}
