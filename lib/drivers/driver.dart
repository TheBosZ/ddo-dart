part of dart_ddo;

abstract class Driver {
	DDO _containerDdo = null;
	List<String> _dbinfo;
	String _errorCode;
	List<String> _errorInfo;
	int _lastInsertId;
	int _affectedRows;

	//Methods
	set containerDdo(DDO ddo) => this._containerDdo = ddo;

	String get errorCode => _errorCode;

	List<String> get errorInfo => _errorInfo;

	int get lastInsertId => _lastInsertId;

	//Abstracts
	Future beginTransaction();

	bool close();

	Future rollBack();

	Future commit();

	Future<DDOResults> exec(String query);

	DDOStatement prepare(String query, [List array = null]);

	DDOStatement query(String query);

	String quote(String value);

	Object getAttribute(int attr);

	bool setAttribute(int attr, Object mixed);
}

