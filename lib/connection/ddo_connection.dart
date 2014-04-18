library ddo_connection;

import 'package:sqljocky/sqljocky.dart'; //Used for ddo_Mysql
import 'dart:async';
import 'dart:mirrors';

part 'ddo_connection_mysql.dart';
part 'ddo_connection_sqlite.dart';

abstract class DDOConnection {

	int _affectedRows;
	int _errorNo;
	String _error;
	List<List> _results;

	int getAffectedRows() {
		return _affectedRows;
	}

	int get errorNo => _errorNo;

	String get error => _error;

	Future<DDOResults> query(String query);

	bool close();
}

class DDOResults {
	int insertId;
	int affectedRows;
	int cursor = 0;
	List<String> fields;
	List<DDOResult> _results = new List<DDOResult>();

	List<DDOResult> get results => _results;

	void add(DDOResult result) => _results.add(result);

	int columnCount() {
		if(_results.isEmpty){
			return -1;
		}
		return results.first.columnCount();
	}

	Object fetchNum() {
		DDOResult row;
		Object ret;
		if((row = _results.elementAt(cursor++)) != null){
			ret = row.row[0];
		}
		return ret;
	}

	DDOResult fetchRow() {
		if(cursor >= _results.length){
			return null;
		}
		return _results.elementAt(cursor++);
	}
}

class DDOResult {
	Map row = new Map();

	DDOResult.fromMap(Map this.row);

	int columnCount() {
		return row.length;
	}

	List<Object> toList() {
		return row.values;
	}

	Object toObject([Type type = null]) {
		if(type != null) {
			ClassMirror cm = reflectClass(type);
			Object newobj = cm.newInstance(const Symbol(""), []);
			//Using code from: http://stackoverflow.com/questions/22317924/obtain-getters-and-or-attribuites-from-classmirror-using-reflection-in-dart
			cm.declarations.forEach((name, declaration){
				VariableMirror field;
				if(declaration is VariableMirror) {
					field = declaration;
					if(field != null) {
						String index = MirrorSystem.getName(field.simpleName);
						if(row.containsKey(index)){
							cm.setField(field.simpleName, row[index]);
						}
					}
				}


			});
		}
		return row;
	}
}