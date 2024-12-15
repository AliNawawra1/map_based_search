class JsonUtils {
  static List<T> jsonToList<T>(
      dynamic data, T Function(Map<String, dynamic>) converter) {
    try {
      if (data is! List) {
        return [];
      }

      return data.map((obj) => converter.call(obj)).toList();
    } catch (e) {
      return [];
    }
  }
}
