import '../ddo.dart';
import 'package:sqljocky/sqljocky.dart';
import 'dart:async'; //Used for ddo_Mysql

class DDOMySQL extends Driver {

	ConnectionPool _connection;

	DDOMySQL(String host, String dbname, String username, String password) {
		List<String> h = host.split(':');
		if (h.length < 2) {
			h.add('3306');
		}

		_connection = new ConnectionPool(host: h.elementAt(0), port: int.parse(h.elementAt(1)), user: username, password: password, db: dbname, max: 5);
		dbinfo = {
			'host': host,
			'username': username,
			'password': password,
			'dbname': dbname
		};
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
			_connection = new ConnectionPool(host: h[0], port: int.parse(h[1]), user: dbinfo[1], password: dbinfo[2], db: dbinfo[3], max: 5);

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
		Completer completer = new Completer();
		_connection.query(query).then((Results results) {
			DDOResults retres = new DDOResults();
			if (results.insertId != null) {
				retres.insertId = results.insertId;
			}
			if (results.affectedRows != null) {
				retres.affectedRows = results.affectedRows;
			}
			retres.fields = new List<String>();
			for (Field field in results.fields) {
				retres.fields.add(field.name);
			}
			results.listen((Row row) {
				retres.add(new DDOResult.fromMap(row.asMap()));
			}).onDone(() {
				completer.complete(retres);
			});
		}, onError: (error) => completer.completeError(error));
		return completer.future;
	}

	bool _close() {
		_connection.close();
		return true;
	}

	String applyLimit(String sql, int offset, int limit) {
		if (limit > 0) {
			String off = offset > 0 ? "${offset}, " : "";
			sql = "${sql} LIMIT ${off} ${limit}";
		} else if (offset > 0) {
			sql = "${sql} LIMIT ${offset}, 18446744073709551615";
		}
		return sql;
	}
}
