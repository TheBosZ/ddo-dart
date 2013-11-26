part of ddo_statement;

class DDOStatementMySQL extends DDOStatement {

  	DDOStatementMySQL(
		String query, connection, List<String> dbInfo, DDO container
		) : super(query, connection, dbInfo, container);


	int columnCount() {
	  // TODO implement this method
	}

	fetch() {
	  // TODO implement this method
	}

	fetchAll() {
	  // TODO implement this method
	}

	fetchColumn() {
	  // TODO implement this method
	}

	int rowCount() {
	  // TODO implement this method
	}

	Future <DDOResults> _uQuery(String query) {
  		return _connection.query(query);
	}
}