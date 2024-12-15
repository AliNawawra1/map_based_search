class JsonUtils {
  static List<T> jsonToList<T>(
      dynamic data, T Function(Map<String, dynamic>) test) {
    try {
      if (data is! List) {
        return [];
      }

      return data.map((obj) => test.call(obj)).toList();
    } catch (e) {
      return [];
    }
  }
}
