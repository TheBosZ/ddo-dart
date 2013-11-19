part of ddo_statement;

class DDOStatementMySQL extends DDOStatement {
  	DDOStatementMySQL(
		String query, connection, List<String> dbInfo, DDO container
		) : super(query, connection, dbInfo, container);


	_uQuery(String query) {
	  // TODO implement this method
	}
}