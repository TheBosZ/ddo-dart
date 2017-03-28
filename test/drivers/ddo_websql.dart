@TestOn('chrome')
import 'package:test/test.dart';
import '../../lib/drivers/ddo_websql.dart';
import '../../lib/ddo.dart';

main() {
	Driver driver = new DDOWebSQL(name: 'ddo_websql_test');
	DDO ddo = new DDO(driver);
	group('Database tests:', () {
		setUp(() async {
			await ddo.exec(
				'CREATE TABLE IF NOT EXISTS person ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"name" TEXT NOT NULL,"created" TEXT NOT NULL)');
		});

		tearDown(() async {
			await ddo.exec('DROP TABLE person');
		});

		test('it should be empty', () async {
			DDOStatement stmt = await ddo.query('SELECT count(*) from person');
			expect(stmt.fetch(DDO.FETCH_NUM), equals(0));

		});

		test('it should insert a row', () async {
			DDOStatement stmt = await ddo.query("INSERT INTO person (name, created) VALUES ('Nathan', '${new DateTime.now().toIso8601String()}')");
			expect(stmt, new isInstanceOf<DDOStatement>());
			stmt = await ddo.query('SELECT count(*) from person');
			expect(stmt.fetch(DDO.FETCH_NUM), equals(1));
		});

	});
}
