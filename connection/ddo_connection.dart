
import 'dart:async';

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
	List<DDOResult> _results = new List<DDOResult>();

	List<DDOResult> get results => _results;

	void add(DDOResult result) => _results.add(result);
}

class DDOResult {
	List row = new List();
}