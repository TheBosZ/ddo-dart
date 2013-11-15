part of ddo;

abstract class Driver {
	DDO _containerDdo = null;

	void setContainerDdo(DDO ddo) {
		this._containerDdo = ddo;
	}

	bool beginTransaction();

	bool close();

	bool rollBack();

	bool commit();

	int exec(String query);

	String errorCode();

	List<String> errorInfo();

	int lastInsertId();

	DDOStatement prepare(String query, [List array = null]);

	DDOStatement query(String query);

	String quote(String value);

	dynamic getAttribute(int attr);

	bool setAttribute(int attr, dynamic mixed);
}

