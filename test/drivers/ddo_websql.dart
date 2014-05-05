import 'package:unittest/unittest.dart';
import '../../lib/drivers/ddo_websql.dart';
import '../../lib/ddo.dart';
import 'package:unittest/html_config.dart';

main() {
	useHtmlConfiguration();
	Driver driver = new DDOWebSQL(name: 'ddo_websql_test');
	DDO ddo = new DDO(driver);
	group('Database tests:', () {
		setUp(() => ddo.exec('CREATE TABLE IF NOT EXISTS person ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"name" TEXT NOT NULL,"created" TEXT NOT NULL)'));
		tearDown(() => ddo.exec('DROP TABLE person'));
		test('it should be empty', () {
			return ddo.query('SELECT count(*) from person').then((DDOStatement stmt) {
				expect(stmt.fetch(DDO.FETCH_NUM), equals(0));
			});
		});
		test('it should insert a row', (){
			expect(ddo.query("INSERT INTO person (name, created) VALUES ('Nathan', '${new DateTime.now().toIso8601String()}')"), completion(new isInstanceOf('DDOStatement')));
			return ddo.query('SELECT count(*) from person').then((DDOStatement stmt) {
				expect(stmt.fetch(DDO.FETCH_NUM), equals(1));
			});
		});

	});
}
