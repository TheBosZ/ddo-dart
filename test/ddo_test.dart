@TestOn('vm')
import 'package:test/test.dart';
import '../lib/ddo.dart';
import '../lib/drivers/ddo_mysql.dart';
@MirrorsUsed(
	targets: 'DDO,Driver',
	override: '*'
)
import 'dart:mirrors';

main() {
	Driver driver = new DDOMySQL('localhost', 'example', 'root', '');
	DDO ddo = new DDO(driver);
	test('Quote correctly', (){
		expect(ddo.quote(r"''\Nathan"), equals("\'\\'\\'\\\\Nathan\'"));
		expect(ddo.quote("1"), equals("'1'"));
	});
	test('Retrieve from database', (){
		expect(ddo.query('select * from person'), completion(new isInstanceOf<DDOStatement>()));
	});
}
