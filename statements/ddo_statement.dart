library ddo_statement;

import '../ddo.dart';
import '../connection/ddo_connection.dart';
import 'dart:async';

class DDOStatement {

	String _query;
	DDOConnection _connection;
	List<String> _dbInfo;
	DDO _containerDdo;
	int _position = 0;
	dynamic _result;
	int _numRows;
	Map<String, dynamic> _namedParams;
	List<dynamic> _boundParams;

	DDOStatement(this._query, this._connection, this._dbInfo, this._containerDdo);

	//Methods
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

	Future <DDOResults> _uQuery(String query) => _connection.query(query);
}