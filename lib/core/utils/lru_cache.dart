import 'dart:collection';

class LRUCache<K, V> {
  final int _capacity;
  final LinkedHashMap<K, V> _cache = LinkedHashMap();

  LRUCache({required int expectedNumItems, double ratio = 1.1})
      : _capacity = (expectedNumItems * ratio).ceil();

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;

    /// Move the accessed key to the end
    final value = _cache.remove(key);
    _cache[key] = value as V;
    return value;
  }

  void set(K key, V value) {
    if (_cache.containsKey(key)) {
      /// Remove the old value
      _cache.remove(key);
    } else if (_cache.length >= _capacity) {
      /// Evict the least recently used item
      _cache.remove(_cache.keys.first);
    }

    _cache[key] = value;
  }

  void clear() => _cache.clear();

  bool containsKey(K key) => _cache.containsKey(key);

  bool get isEmpty => _cache.isEmpty;
}
