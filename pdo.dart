/*
 * A port of the PDO library to Dart
 */

library ddo;
part 'drivers/driver.dart';
part 'drivers/ddo_mysql.dart';
part 'statements/ddo_statement.dart';

class DDO {
	static const FETCH_ASSOC = 2;
	static const FETCH_NUM = 3;
	static const FETCH_BOTH = 4;
	static const FETCH_OBJ = 5;
	static const FETCH_COLUMN = 7;
	static const FETCH_LAZY = 1;
	static const FETCH_BOUND = 6;
	static const FETCH_CLASS = 8;

	static const ATTR_ERRMODE = 3;
	static const ATTR_SERVER_VERSION = 4;
	static const ATTR_CLIENT_VERSION = 5;
	static const ATTR_SERVER_INFO = 6;
	static const ATTR_PERSISTENT = 12;
	static const ATTR_STATEMENT_CLASS = 13;

	static const ERRMODE_EXCEPTION = 2;

	static const PARAM_BOOL = 5;
	static const PARAM_NULL = 0;
	static const PARAM_INT = 1;
	static const PARAM_STR = 2;
	static const PARAM_LOB = 3;

	Driver _driver;

	void DDO(String dsn, [String username = '', String password = '', List<String> driver_options = null] ){
		Map<String, String> con = _getDsn(dsn);
		switch(con['type']){
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
		_driver.setContainerDdo(this);
	}

	Map<String, String> _getDsn(String dsn){
		List<String> params, tmp;
		Map<String, String> result = new Map<String, String>();
		int pos = dsn.indexOf(':');
		params = dsn.substring(pos+1).split(';');
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
}
