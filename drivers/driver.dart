part of ddo;

abstract class Driver {
	DDO _containerDdo = null;

	void setContainerDdo(DDO ddo) {
		this._containerDdo = ddo;
	}

	Future beginTransaction();

	bool close();

	Future rollBack();

	Future commit();

	Future exec(String query);

	String errorCode();

	List<String> errorInfo();

	int lastInsertId();

	DDOStatement prepare(String query, [List array = null]);

	DDOStatement query(String query);

	String quote(String value);

	dynamic getAttribute(int attr);

	bool setAttribute(int attr, dynamic mixed);
}

