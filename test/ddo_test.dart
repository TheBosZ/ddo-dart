library ddo_test;

import 'package:unittest/unittest.dart';
import '../lib/ddo.dart';

main() {
	String dsn = 'mysql:host=localhost;dbname=wishlist';
	DDO ddo = new DDO(dsn: dsn, username: 'root', password: 'k7nqs');
	test('Quote correctly', (){
		expect(ddo.quote(r"''\Nathan"), equals("\'\\'\\'\\\\Nathan\'"));
		expect(ddo.quote("1"), equals("'1'"));
	});
}