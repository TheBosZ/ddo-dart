# Dart Data Objects

A port of [PHP Data Objects to Dart](http://php.net/pdo).

DDO is an abstraction framework for accessing databases from Dart.

Note that this library is only to abstract the way the user interacts with a database, it doesn't rewrite SQL or implement missing features.

By extending the [base driver](lib/drivers/driver.dart), any database connection can be used. Two have been included, one for [MySQL](lib/drivers/ddo_mysql.dart) and [WebSQL](lib/drivers/ddo_websql.dart).

## Installation

In your pubspec.yaml file, add a dependency on "ddo". Since breaking changes are likely to happen (given the immaturity of this project), you should depend on a specific version like so:

````Yaml
dependencies:
  ddo: ">=0.2.2 <0.3.0"
````

Import the main library:

````Dart
import 'package:ddo/ddo.dart';
````

Also make sure to import your desired driver

````Dart
import 'package:ddo/drivers/ddo_mysql.dart';
````

The MySQL driver depends on [SQLJocky](https://github.com/jamesots/sqljocky) so include that in your pubspec.yaml if you are connecting to a MySQL database.

## Usage
Create a new Driver object:

````Dart
Driver driver = new DDOMySQL('127.0.0.1', 'example', 'root', '');
````

Create a new DDO object by injecting your Driver:

````Dart
DDO ddo = new DDO(driver);
````

Query the database using the DDO object:

````Dart
ddo.query('select * from user');
````

Any direct database access is accomplished using Futures. Make sure you understand them and are comfortable using them.

The query method returns a Future<DDOStatement>. DDOStatement is the main class to handle the results from the database. There are 3 main ways to retrieve information from a DDOStatement: fetch(), fetchAll(), and fetchColumn().

Fetch will return a single row at a time while fetchAll will return all rows as a List. FetchColumn will return a List of values of the sent column (for now, it only returns the first row's values, this part is incomplete). 

What is returned by fetch and fetchAll depends on the fetch mode. The fetch mode can either be set on the statement itself or it can be set for each call to fetch and fetchAll.

FETCH_ASSOC will return a Map with the Keys being the column names and the values being the column values. FETCH_CLASS will use Mirrors to dynamically create an Object of the set class and return that. It works based on matching properties to column names.

Except for FETCH_CLASS, the returned value will be a DDOResult object (for fetch) or a DDOResults object (for fetchAll). A DDOResults object has many DDOResult results. A DDOResult has a row object containing the values retrieved from the database. This may be an unnecessary abstraction, so I'll revisit this in the future

## Full Example
This example will query the user table and print out, for every row, every column and its values. Note that the database schema `example` needs to exist and the connection parameters need to be correct.

````Dart
import 'package:ddo/ddo.dart';
import 'package:ddo/drivers/ddo_mysql.dart';

main() async {
	Driver driver = new DDOMySQL('127.0.0.1', 'example', 'root', 'password');
	DDO ddo = new DDO(driver);
	await ddo.exec('DROP TABLE IF EXISTS person');
	await ddo.exec('''
		CREATE TABLE IF NOT EXISTS `person` (
	`id` INT NOT NULL AUTO_INCREMENT,
		`name` VARCHAR(200) NOT NULL,
	`created` DATE NOT NULL,
	PRIMARY KEY (`id`));
	''');
	var now = new DateTime.now().toIso8601String();
	for(var x = 1; x <= 10; x++) {
		await ddo.exec("INSERT INTO person (`name`, `created`) VALUES ('person-${x}', '${now}')");
	}

	DDOStatement stmt = await ddo.query('select * from person');
	var results = stmt.fetchAll(DDO.FETCH_ASSOC);
	for(Map<String, dynamic> row in results) {
		for (String cName in row.keys) {
			print("Column '${cName}' has value '${row[cName]}'");
		}
	}
}
````


