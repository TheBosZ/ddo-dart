library ddo_test;

import 'package:unittest/unittest.dart';
import '../lib/ddo.dart';
import '../lib/drivers/ddo_mysql.dart';

main() {
	Driver driver = new DDOMySQL('127.0.0.1', 'wishlist', 'root', 'kc7nqs');
	DDO ddo = new DDO(driver);
	test('Quote correctly', (){
		expect(ddo.quote(r"''\Nathan"), equals("\'\\'\\'\\\\Nathan\'"));
		expect(ddo.quote("1"), equals("'1'"));
	});
	test('Retrieve from database', (){
		expect(ddo.query('select * from user'), completion(new isInstanceOf<DDOStatement>()));
	});
}