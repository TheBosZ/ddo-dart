part of ddo_connection;

class DDOConnectionMySQL extends DDOConnection {

	ConnectionPool _connection;

	DDOConnectionMySQL({String host,
			int port,
			String user,
			String password,
			String db}){
		_connection = new ConnectionPool(host: host, port: port, user: user, password: password, db: db, max: 5);
	}

	Future<DDOResults> query(String query) {
		Completer completer = new Completer();
		_connection.query(query).then((Results results) {
			DDOResults retres = new DDOResults();
			if(results.insertId != null) {
				retres.insertId = results.insertId;
			}
			if(results.affectedRows != null) {
				retres.affectedRows = results.affectedRows;
			}
			retres.fields = new List<String>();
			for(Field field in results.fields) {
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

	bool close() {
		_connection.close();
		return true;
	}
}