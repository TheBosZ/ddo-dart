import '../ddo.dart';
import 'package:postgresql/postgresql.dart';
import 'package:postgresql/postgresql_pool.dart';
import 'dart:async'; //Used for ddo_Mysql

class DDOPostgres extends Driver {

	Pool _connectionPool;

	DDOPostgres(String host, String dbname, String username, String password, [bool sslmode = false]) {
		int port;

		List<String> h = host.split(':');
		String tempHost;
		if (h.length < 2) {
			port = 5432;
			tempHost = "${host}:5432";
		} else {
			port = int.parse(h[1]);
		}

		_connectionPool = new Pool(_buildUri(h.first, dbname, port, username, password, sslmode));

		dbinfo = {
			'host': tempHost,
			'username': username,
			'password': password,
			'dbname': dbname,
			'ssl': sslmode.toString(),
			'driver': 'mysql',
		};
	}

	Future<Connection> _getConnection() {
		return _connectionPool.connect();
	}

	String _buildUri(String host, String dbname, int port, String username, String password, [bool sslmode = false]) {
		return "postgres://${username}:${password}@${host}:${port.toString()}/${dbname}${sslmode ? '?sslmode=require':''}";
	}

	Future<int> beginTransaction() => exec("BEGIN");

	bool close() => _close();

	Future<int> commit() => exec("COMMIT");

	// Per http://dev.mysql.com/doc/refman/5.0/en/mysql-real-escape-string.html,
	// only backslash and single quote need to be escaped
	String quote(String value) => "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";

	Future<int> rollBack() => exec("ROLLBACK");

	bool setAttribute(int attr, Object mixed) {
		bool result = false;
		if (attr == DDO.ATTR_ERRMODE && mixed == DDO.ERRMODE_EXCEPTION) {
			throwExceptions = true;
		} else if (attr == DDO.ATTR_STATEMENT_CLASS && mixed is List && mixed[0] == 'LoggedDDOStatement') {
			logging = true;
		} else if (attr == DDO.ATTR_PERSISTENT && mixed != persistent) {
			result = true;
			persistent = (mixed as bool);
			_close();
			//We should be checking persistent here and opening a persistent connection or not.
			//Right now, persistent connections aren't supported
			List<String> h = dbinfo['host'].split(':');
			_connectionPool = new Pool(_buildUri(h.first, dbinfo['dbname'], int.parse(h[1]), dbinfo['username'], dbinfo['password'], dbinfo['sslmode'] == true.toString()));
		}
		return result;
	}

	Object getAttribute(int attr) {
		Object result = false;
		switch (attr) {
			case DDO.ATTR_SERVER_INFO:
				break;
			case DDO.ATTR_SERVER_VERSION:
				break;
			case DDO.ATTR_CLIENT_VERSION:
				break;
			case DDO.ATTR_PERSISTENT:
				result = persistent;
				break;
		}
		return result;
	}

	Object quoteIdentifier(Object val) {
		if (val is List) {
			return (val.map((v) => quoteIdentifier(v)).toList());
		}

		if (val is String) {
			if (val.contains(new RegExp(r'[" (\*]'))) {
				return val;
			}
			return '"${val.replaceAll('.', '","')}"';
		}

		return val;
	}

	Future<DDOResults> uQuery(String query) {
		return _getConnection().then((Connection connection){
			return connection.query(query).toList().then((List<Row> results) {
				DDOResults retres = new DDOResults();
				retres.fields = new List<String>();

				for(Row row in results) {
					row.forEach((String col, Object val){
						if (!retres.fields.contains(col)) {
							retres.fields.add(col);
						}
						retres.add(new DDOResult.fromMap({col: val}));
					});
				}
				return retres;
			});
		});
	}

	bool _close() {
		_connectionPool.destroy();
		return true;
	}

	String applyLimit(String sql, int offset, int limit) {
		if (limit > 0) {
			sql = "${sql} LIMIT ${limit}";
		}
		if (offset > 0) {
			sql = "${sql} OFFSET ${offset}";
		}
		return sql;
	}
}
