part of ddo_statement;

class DDOStatementMySQL extends DDOStatement {
  DDOStatementMySQL(String query, DDOConnection connection, List<String> dbInfo, DDO containerDdo) : super(query, connection, dbInfo, containerDdo);


  @override
  Future<DDOResults> _uQuery(String query) {
    // TODO: implement _uQuery
  }

  @override
  int columnCount() {
    // TODO: implement columnCount
  }

  @override
  Object fetch() {
    // TODO: implement fetch
  }

  @override
  List<Object> fetchAll() {
    // TODO: implement fetchAll
  }

  @override
  Object fetchColumn() {
    // TODO: implement fetchColumn
  }

  @override
  int rowCount() {
    // TODO: implement rowCount
  }
}