class StringFormat {
	static String className(String string) => StringFormat.titleCase(string);

	static String classMethod(String string) => StringFormat.lcFirst(StringFormat.titleCase(string));

	static String pluralClassMethod(String string) => StringFormat.lcFirst(StringFormat.plural(StringFormat.titleCase(string)));

	static String classProperty(String string) => StringFormat.lcFirst(StringFormat.titleCase(string));

	static String pluralClassPropety(String string) =>
		StringFormat.lcFirst(StringFormat.plural(StringFormat.titleCase(string)));

	static String url(String string) => StringFormat.variable(string).replaceAll('_','-');

	static String pluralUrl(String string) => StringFormat.url(StringFormat.pluralVariable(string));

	static String variable(String string) => StringFormat.getWords(string, true).join('_');

	static String constant(String string) => StringFormat.variable(string).toUpperCase();

	static String pluralVariable(String string) => StringFormat.plural(StringFormat.variable(string));

	static String titleCase(String string, [String delimiter = '']) => StringFormat.getWords(string, true).map((String t) => StringFormat.ucFirst(t)).join(delimiter);

	static List<String> getWords(String string, [bool lowercase = false]) {
		String t = StringFormat.clean(string, ' ');
		t = t.replaceAllMapped(new RegExp('(.)([A-Z])([a-z])'), (match) => '${match.group(1)} ${match.group(2)}${match.group(3)}');
		t = t.replaceAllMapped(new RegExp('([a-z])([A-Z])'), (match) => '${match.group(1)} ${match.group(2)}');
		t = t.replaceAllMapped(new RegExp('([0-9])([^0-9])'), (match) => '${match.group(1)} ${match.group(2)}');
		if(lowercase) {
			t = t.toLowerCase();
		}
		t = t.replaceAll('  ', ' ');
		return t.split(' ');
	}

	static String plural(String string) {
		Map<RegExp, String> plural = {
			new RegExp(r'(quiz)$', caseSensitive: false): r"zes",
			new RegExp(r'^(ox)$', caseSensitive: false): r"en",
			new RegExp(r'([m|l])ouse$', caseSensitive: false): r"ice",
			new RegExp(r'(matr|vert|ind)ix|ex$', caseSensitive: false): r"ices",
			new RegExp(r'(x|ch|ss|sh)$', caseSensitive: false): r"es",
			new RegExp(r'([^aeiouy]|qu)y$', caseSensitive: false): r"ies",
			new RegExp(r'([^aeiouy]|qu)ies$', caseSensitive: false): r"y",
			new RegExp(r'(hive|move)$', caseSensitive: false): r"s",
			new RegExp(r'(?:([^f])fe|([lr])f)$', caseSensitive: false): r"$2ves",
			new RegExp(r'sis$', caseSensitive: false): "ses",
			new RegExp(r'([ti])um$', caseSensitive: false): r"a",
			new RegExp(r'(buffal|tomat)o$', caseSensitive: false): r"oes",
			new RegExp(r'(bu)s$', caseSensitive: false): r"ses",
			new RegExp(r'(alias|status|campus)$', caseSensitive: false): r"es",
			new RegExp(r'(octop|cact|vir)us$', caseSensitive: false): r"i",
			new RegExp(r'(ax|test)is$', caseSensitive: false): r"es",
			new RegExp(r'^(m|wom)an$', caseSensitive: false): r"en",
			new RegExp(r'(child)$', caseSensitive: false): r"ren",
			new RegExp(r'(p)erson$', caseSensitive: false): r"eople",
			new RegExp(r's$', caseSensitive: false): r"s",
			new RegExp(r'$/'): r"s",
			};

		List<String> words = StringFormat.getWords(string);
		String word = words.first;

		for(RegExp pattern in plural.keys) {
			if(pattern.hasMatch(word)) {
				String prefix = string.substring(0, string.lastIndexOf(word));
				return "${prefix}${word.replaceAll(pattern, plural[pattern])}";
			}
		}
		return "${string}s";
	}

	static String removeAccents(String str) {
		List<String> a = ['À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', 'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'ß', 'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', 'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'ÿ', 'Ā', 'ā', 'Ă', 'ă', 'Ą', 'ą', 'Ć', 'ć', 'Ĉ', 'ĉ', 'Ċ', 'ċ', 'Č', 'č', 'Ď', 'ď', 'Đ', 'đ', 'Ē', 'ē', 'Ĕ', 'ĕ', 'Ė', 'ė', 'Ę', 'ę', 'Ě', 'ě', 'Ĝ', 'ĝ', 'Ğ', 'ğ', 'Ġ', 'ġ', 'Ģ', 'ģ', 'Ĥ', 'ĥ', 'Ħ', 'ħ', 'Ĩ', 'ĩ', 'Ī', 'ī', 'Ĭ', 'ĭ', 'Į', 'į', 'İ', 'ı', 'Ĳ', 'ĳ', 'Ĵ', 'ĵ', 'Ķ', 'ķ', 'Ĺ', 'ĺ', 'Ļ', 'ļ', 'Ľ', 'ľ', 'Ŀ', 'ŀ', 'Ł', 'ł', 'Ń', 'ń', 'Ņ', 'ņ', 'Ň', 'ň', 'ŉ', 'Ō', 'ō', 'Ŏ', 'ŏ', 'Ő', 'ő', 'Œ', 'œ', 'Ŕ', 'ŕ', 'Ŗ', 'ŗ', 'Ř', 'ř', 'Ś', 'ś', 'Ŝ', 'ŝ', 'Ş', 'ş', 'Š', 'š', 'Ţ', 'ţ', 'Ť', 'ť', 'Ŧ', 'ŧ', 'Ũ', 'ũ', 'Ū', 'ū', 'Ŭ', 'ŭ', 'Ů', 'ů', 'Ű', 'ű', 'Ų', 'ų', 'Ŵ', 'ŵ', 'Ŷ', 'ŷ', 'Ÿ', 'Ź', 'ź', 'Ż', 'ż', 'Ž', 'ž', 'ſ', 'ƒ', 'Ơ', 'ơ', 'Ư', 'ư', 'Ǎ', 'ǎ', 'Ǐ', 'ǐ', 'Ǒ', 'ǒ', 'Ǔ', 'ǔ', 'Ǖ', 'ǖ', 'Ǘ', 'ǘ', 'Ǚ', 'ǚ', 'Ǜ', 'ǜ', 'Ǻ', 'ǻ', 'Ǽ', 'ǽ', 'Ǿ', 'ǿ'];
		List<String> b = ['A', 'A', 'A', 'A', 'A', 'A', 'AE', 'C', 'E', 'E', 'E', 'E', 'I', 'I', 'I', 'I', 'D', 'N', 'O', 'O', 'O', 'O', 'O', 'O', 'U', 'U', 'U', 'U', 'Y', 's', 'a', 'a', 'a', 'a', 'a', 'a', 'ae', 'c', 'e', 'e', 'e', 'e', 'i', 'i', 'i', 'i', 'n', 'o', 'o', 'o', 'o', 'o', 'o', 'u', 'u', 'u', 'u', 'y', 'y', 'A', 'a', 'A', 'a', 'A', 'a', 'C', 'c', 'C', 'c', 'C', 'c', 'C', 'c', 'D', 'd', 'D', 'd', 'E', 'e', 'E', 'e', 'E', 'e', 'E', 'e', 'E', 'e', 'G', 'g', 'G', 'g', 'G', 'g', 'G', 'g', 'H', 'h', 'H', 'h', 'I', 'i', 'I', 'i', 'I', 'i', 'I', 'i', 'I', 'i', 'IJ', 'ij', 'J', 'j', 'K', 'k', 'L', 'l', 'L', 'l', 'L', 'l', 'L', 'l', 'l', 'l', 'N', 'n', 'N', 'n', 'N', 'n', 'n', 'O', 'o', 'O', 'o', 'O', 'o', 'OE', 'oe', 'R', 'r', 'R', 'r', 'R', 'r', 'S', 's', 'S', 's', 'S', 's', 'S', 's', 'T', 't', 'T', 't', 'T', 't', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'W', 'w', 'Y', 'y', 'Y', 'Z', 'z', 'Z', 'z', 'Z', 'z', 's', 'f', 'O', 'o', 'U', 'u', 'A', 'a', 'I', 'i', 'O', 'o', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'U', 'u', 'A', 'a', 'AE', 'ae', 'O', 'o'];
		for(int x = 0; x < a.length; ++x) {
			str = str.replaceAll(a.elementAt(x), b.elementAt(x));
		}
		return str;
	}

	static String clean(String str, [String delimiter = ' ']) {
		str = StringFormat.removeAccents(str);

		str = str.replaceAllMapped(
				new RegExp(r"([a-zA-Z])'([a-zA-Z])"),
				(match) => "${match.group(0)}${match.group(1)}");

		str = str.replaceAll(new RegExp(r'[^a-zA-Z0-9]'), ' ');

		str = str.trim();

		str = str.replaceAll('  ', ' ');

		if(delimiter != ' ') {
			str = str.replaceAll(' ', delimiter);
		}
		return str;
	}

	static String lcFirst(String str) {
		if(str.length > 1) {
			return "${str.substring(0, 1).toLowerCase()}${str.substring(1)}";
		}
		return str.toLowerCase();
	}

	static String ucFirst(String str) {
		if(str.length > 1) {
			return "${str.substring(0, 1).toUpperCase()}${str.substring(1)}";
		}
		return str.toUpperCase();
	}

}