part of ddo;

class DDOResults {
	int insertId;
	int affectedRows;
	int cursor = 0;
	List<String> fields;
	List<DDOResult> _results = new List<DDOResult>();

	List<DDOResult> get results => _results;

	void add(DDOResult result) => _results.add(result);

	int columnCount() {
		if (_results.isEmpty) {
			return -1;
		}
		return results.first.columnCount();
	}

	Object fetchNum() {
		DDOResult row;
		Object ret;
		if ((row = _results.elementAt(cursor++)) != null) {
			ret = row.row.values.first;
		}
		return ret;
	}

	DDOResult fetchRow() {
		if (cursor >= _results.length) {
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
		return row.values.toList();
	}

	//This should probably not be here. At least it should take a ClassMirror so it doesn't have to reflect
	//Also the dependency on how Dabl generates setters is not ideal
	Object toObject([ClassMirror cm = null]) {
		Object newobj;
		if (cm != null) {
			newobj = cm.newInstance(const Symbol(""), []).reflectee;
			InstanceMirror im = reflect(newobj);
			LibraryMirror foundLib;
			List<String> probs = new List<String>();
			//Using code from: http://stackoverflow.com/questions/22317924
			for (Symbol name in cm.instanceMembers.keys) {
				MethodMirror declaration = cm.instanceMembers[name];

				if (declaration.isSetter) {

					String index = MirrorSystem.getName(declaration.simpleName);
					String trimmedIndex = index.substring(index.indexOf('_') == 0 ? 1 : 0, index.lastIndexOf('='));
					if (row.containsKey(trimmedIndex)) {
						Type fieldType = declaration.parameters.first.type.reflectedType;
						bool found = false;
						var symb;
						var value = row[trimmedIndex];
						if(fieldType == int) {
							if(value != null && value.toString() != 'null') {
								try {
									value = int.parse(value);
								} catch (e) {
									throw e;
								}
							}
						}
						if (foundLib != null) {
							try {
								symb = MirrorSystem.getSymbol("${trimmedIndex}", foundLib);

								im.setField(symb, value);
								found = true;
							} catch (e) {

							}
						} else {
							for (LibraryMirror lib in currentMirrorSystem().libraries.values) {
								try {
									symb = MirrorSystem.getSymbol("${trimmedIndex}", lib);
									im.setField(symb, value);
									found = true;
									foundLib = lib;
									break;
								} catch (e) {

								}
							}
						}
						if (!found) {
							probs.add(trimmedIndex);
							//throw new Exception('Could not find library for ${newobj.runtimeType.toString()}:${trimmedIndex}');
						}
					}
				}
			}
		}

		return newobj;
	}
}
