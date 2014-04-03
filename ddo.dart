/*
 * A port of the PDO library to Dart
 */
library dart_ddo;

import 'statements/ddo_statement.dart';
import 'connection/ddo_connection_mysql.dart';
import 'dart:async';

export 'connection/ddo_connection_mysql.dart';

part 'drivers/driver.dart';
part 'drivers/ddo_mysql.dart';


class DDO {
	static const int FETCH_ASSOC = 2;
	static const int FETCH_NUM = 3;
	static const int FETCH_BOTH = 4;
	static const int FETCH_OBJ = 5;
	static const int FETCH_COLUMN = 7;
	static const int FETCH_LAZY = 1;
	static const int FETCH_BOUND = 6;
	static const int FETCH_CLASS = 8;

	static const int ATTR_ERRMODE = 3;
	static const int ATTR_SERVER_VERSION = 4;
	static const int ATTR_CLIENT_VERSION = 5;
	static const int ATTR_SERVER_INFO = 6;
	static const int ATTR_PERSISTENT = 12;
	static const int ATTR_STATEMENT_CLASS = 13;

	static const int ERRMODE_EXCEPTION = 2;

	static const int PARAM_BOOL = 5;
	static const int PARAM_NULL = 0;
	static const int PARAM_INT = 1;
	static const int PARAM_STR = 2;
	static const int PARAM_LOB = 3;

	Driver _driver;

	DDO({String dsn, String username: '', String password: '', List<String> driver_options: null}){
		Map<String, String> con = _getDsn(dsn);
		switch(con['dbtype']){
			case 'mysql':
				if(con.containsKey('port')){
					con['host'] += ':' + con['port'];
				}
				_driver = new DDOMySQL(
					con['host'],
					con['dbname'],
					username,
					password
				);
				break;
			case 'sqlite2':
			case 'sqlite':
				//Undefined
				break;
			case 'pgsql':
				//Undefined
				break;
			default:
				throw new Exception('Unknown database type "${con['type']}"');
		}
		_driver.containerDdo = this;
	}

	Map<String, String> _getDsn(String dsn){
		List<String> params, tmp;
		Map<String, String> result = new Map<String, String>();
		int pos = dsn.indexOf(':');
		params = dsn.substring(pos+1).split(';');
		result['dbtype'] = dsn.substring(0, pos).toLowerCase();
		for(String str in params) {
			tmp = str.split('=');
			if(tmp.length == 2){
				result[tmp[0]] = tmp[1];
			} else {
				result['dbname'] = str;
			}
		}
		return result;
	}

	Future beginTransaction() => _driver.beginTransaction();

	Future commit() => _driver.commit();

	Future rollBack() => _driver.rollBack();

	bool close() => _driver.close();

	String get errorCode => _driver.errorCode;

	List<String> get errorInfo => _driver.errorInfo;

	int get lastInsertId => _driver.lastInsertId;

	DDOStatement prepare(String query, [List array = null]) => _driver.prepare(query, array);

	DDOStatement query(String query) => _driver.query(query);

	String quote(String val) => _driver.quote(val);

	bool setAttribute(int attr, dynamic mixed) => _driver.setAttribute(attr, mixed);

	dynamic getAttribute(int attr) => _driver.getAttribute(attr);

	/*
	 * Not implemented:
	 * __call
	 * __set
	 * __get
	 */

}
