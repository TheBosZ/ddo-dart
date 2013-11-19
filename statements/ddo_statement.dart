library ddo_statement;

import '../ddo.dart';

part 'ddo_statement_mysql.dart';

abstract class DDOStatement {

	String _query;
	dynamic _connection;
	List<String> _dbInfo;
	DDO _containerDdo;
	int _position;
	dynamic _result;

	DDOStatement(String query, dynamic connection, List<String> dbInfo, DDO container) {
		_query = query;
		_connection = connection;
		_dbInfo = dbInfo;
		_containerDdo = container;
		_position = 0;
	}

	bool query() {
		_result = _uQuery(_query);
		return _result == null;
	}

	dynamic _uQuery(String query);
}