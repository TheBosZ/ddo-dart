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
	int _numRows;
	Map<String, dynamic> _namedParams;
	List<dynamic> _boundParams;

	DDOStatement(String query, dynamic connection, List<String> dbInfo, DDO container) {
		_query = query;
		_connection = connection;
		_dbInfo = dbInfo;
		_containerDdo = container;
		_position = 0;
	}

	dynamic _uQuery(String query);

	dynamic fetch();

	dynamic fetchAll();

	dynamic fetchColumn();

	dynamic columnCount();

	int rowCount();

	bool query() {
		_result = _uQuery(_query);
		return _result == null;
	}

	void rewind() {

	}

	void next() {
		++_position;
	}

	dynamic current([int mode = null]){
		if(mode == null) {
			mode = DDO.FETCH_BOTH;
		}
		return fetch();
	}

	int key() {
		return _position;
	}

	bool valid() {
		if(_numRows == null) {
			throw new Exception('Row count not specified');
		}
		return _position < _numRows;
	}

	void bindParam(dynamic mixed, dynamic variable, [int type = null, int length = null]) {
		if(mixed is String) {
			_namedParams[mixed] = variable;
		} else {
			_boundParams.add(variable);
		}
	}

	//What's the difference between this and bindParam?
	void bindValue(dynamic mixed, dynamic variable, [int type = null, int length = null]) {
		bindParam(mixed, variable, type, length);
	}

	bool bindColumn(dynamic mixed, dynamic param, [int type = null, int maxLength = null, dynamic driverOption = null]) {
		//Not supported.
		return false;
	}

	bool execute([List arr = null]) {

	}

}