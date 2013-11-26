part of ddo;

abstract class Driver {
	DDO _containerDdo = null;
	List<String> _dbinfo;
	String _errorCode;
	List<String> _errorInfo;
	int _lastInsertId;
	int _affectedRows;

	void setContainerDdo(DDO ddo) {
		this._containerDdo = ddo;
	}

	Future beginTransaction();

	bool close();

	Future rollBack();

	Future commit();

	Future<DDOResults> exec(String query);

	String errorCode();

	List<String> errorInfo();

	int lastInsertId();

	DDOStatement prepare(String query, [List array = null]);

	DDOStatement query(String query);

	String quote(String value);

	dynamic getAttribute(int attr);

	bool setAttribute(int attr, dynamic mixed);
}

