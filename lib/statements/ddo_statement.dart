library ddo_statement;

import '../ddo.dart';
import '../connection/ddo_connection.dart';
import 'dart:async';

//I keep going back and forth whether there needs to be individual statement classes
//per driver. I *think* statements are abstract enough

class DDOStatement {

	String _query;
	DDOConnection _connection;
	List<String> _dbInfo;
	DDO _containerDdo;
	int _position = 0;
	DDOResults _result;
	int _numRows;
	Map<String, Object> _namedParams;
	List<Object> _boundParams;
	Type _fetchClass;
	int _fetchMode;
	String _errorCode;
	List _errorInfo;

	DDOStatement(this._query, this._connection, this._dbInfo, this._containerDdo);

	Future<DDOResults> _uQuery(String query) {
		return _connection.query(query).then((DDOResults results) {
			_result = results;
			return results;
		});
	}

	int columnCount() {
		return _result.columnCount();
	}

	Object fetch([int mode = null, Object cursor = null, int offset = null]) {
		if (mode == null) {
			mode = _fetchMode;
		}
		if (mode == null) {
			mode == DDO.FETCH_BOTH;
		}
		Object result = false;
		if (_result != null) {
			switch (mode) {
				case DDO.FETCH_NUM:
					result = _result.fetchRow();
			}
		}
		return result;
	}

	List<Object> fetchAll([int mode = DDO.FETCH_BOTH, int colIndex = 0]) {
		List<Object> results = null;
		if (mode != null) {
			switch (mode) {
				case DDO.FETCH_NUM:
					results = new List<List<Object>>();
					DDOResult r;
					while ((r = _result.fetchRow()) != null) {
						results.add(r.toList());
					}
					break;
				case DDO.FETCH_ASSOC:
					results = new List<Map<Object, Object>>();
					DDOResult r;
					while ((r = _result.fetchRow()) != null) {
						results.add(r.row);
					}
					break;
				case DDO.FETCH_COLUMN:
					results = new List<Object>();
					DDOResult r;
					while ((r = _result.fetchRow()) != null) {
						results.add(r.row[colIndex]);
					}
					break;
				case DDO.FETCH_OBJ:
					results = new List<Object>();
					DDOResult r;
					while ((r = _result.fetchRow()) != null) {
						results.add(r.toObject());
					}
					break;
				case DDO.FETCH_CLASS:
					DDOResult r;
					List<Object> results = new List<Object>();
					while ((r = _result.fetchNum()) != null) {
						results.add(r.toObject(_fetchClass));
					}
					break;
				case DDO.FETCH_BOTH:
					throw new UnimplementedError('FETCH_BOTH not implemented yet');
				default:
					break;
			}
		}
		return results;
	}

	Future<Object> fetchColumn() {
		throw new UnimplementedError('Not yet implemented');
	}

	Future<int> rowCount() {
		throw new UnimplementedError('Not yet implemented');
	}

	//Implemented methods
	Future<bool> query() {
		return _uQuery(_query).then((result) {
			_result = result;
			return result != null;
		});
	}

	void rewind() {

	}

	void next() {
		++_position;
	}

	Object current([int mode = DDO.FETCH_BOTH]) {
		return fetch();
	}

	int key() {
		return _position;
	}

	bool valid() {
		if (_numRows == null) {
			throw new Exception('Row count not specified');
		}
		return _position < _numRows;
	}

	void bindParam(Object mixed, String variable, [int type = null, int length = null]) {
		if (mixed is String) {
			_namedParams[mixed] = variable;
		} else {
			_boundParams.add(variable);
		}
	}

	//What's the difference between this and bindParam?
	void bindValue(Object mixed, String variable, [int type = null, int length = null]) {
		bindParam(mixed, variable, type, length);
	}

	bool bindColumn(Object mixed, Object param, [int type = null, int maxLength = null, Object driverOption = null]) {
		//Not supported.
		return false;
	}

	Future<bool> execute([List arr = null]) {
		if (_boundParams != null && _boundParams.length > 0) {
			arr = _boundParams;
		}
		String query = _query;
		if (arr != null && arr.length > 0) {
			if (_namedParams.length > 0) {
				_namedParams.forEach((k, v) {
					query.replaceAll(k, _containerDdo.quote(v));
				});
			} else {
				//do regular params
				List params = prepareInput(_boundParams);
				if (params.length != '?'.allMatches(query).length) {
					throw new Exception('Number of params doesn\'t match number of ?s');
				}
				query = query.replaceAllMapped('?', (Match m) {
					return params.removeAt(0);
				});
			}
		}
		_namedParams = new Map();
		_boundParams = new List();
		return _uQuery(query).then((result) {
			_result = result;
			return result != null;
		});
	}

	Object prepareInput(Object value) {
		if (value is List) {
			return value.map((v) => prepareInput(v));
		}

		if (value is int) {
			return value;
		}

		if (value is bool) {
			return value ? 1 : 0;
		}

		if (value == null) {
			return 'NULL';
		}

		return _containerDdo.quote(value);
	}

	bool setFetchMode(int mode, [Type cla = null]) {
		bool result = false;
		switch (mode) {
			case DDO.FETCH_CLASS:
				_fetchClass = cla;
				result = true;
				_fetchMode = mode;
				break;
			case DDO.FETCH_NUM:
			case DDO.FETCH_ASSOC:
			case DDO.FETCH_ASSOC:
			case DDO.FETCH_OBJ:
			case DDO.FETCH_BOTH:
				result = true;
				_fetchMode = mode;
				break;
		}
		return result;
	}

	Object getAttribute(int attr) {
		return _containerDdo.getAttribute(attr);
	}

	bool setAttribute(int attr, Object value) {
		return _containerDdo.setAttribute(attr, value);
	}

	String errorCode() {
		return _errorCode;
	}

	List errorInfo() {
		return _errorInfo;
	}

}
