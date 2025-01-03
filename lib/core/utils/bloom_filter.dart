import 'dart:math';
import 'dart:typed_data';

class BloomFilter {
  final int bitArraySize;
  final int hashFunctions;
  final Uint8List bitArray;
  final double falsePositiveRate;

  BloomFilter._({
    required this.bitArraySize,
    required this.hashFunctions,
    required this.bitArray,
    required this.falsePositiveRate,
  });

  factory BloomFilter({required int expectedNumItems}) {
    final bitArraySize = _calculateBitArraySize(expectedNumItems);
    final hashFunctions =
        _calculateNumHashFunctions(expectedNumItems, bitArraySize);
    final bitArray = Uint8List((bitArraySize + 7) ~/ 8);

    final falsePositiveRate = _calculateFalsePositiveRate(
        expectedNumItems, bitArraySize, hashFunctions);

    return BloomFilter._(
      bitArraySize: bitArraySize,
      hashFunctions: hashFunctions,
      bitArray: bitArray,
      falsePositiveRate: falsePositiveRate,
    );
  }

  static int _calculateBitArraySize(int expectedNumItems) {
    const desiredFalsePositiveRate = 0.01;
    return (-expectedNumItems * log(desiredFalsePositiveRate) / pow(log(2), 2))
        .ceil();
  }

  static int _calculateNumHashFunctions(
      int expectedNumItems, int bitArraySize) {
    return (bitArraySize / expectedNumItems * log(2)).ceil();
  }

  static double _calculateFalsePositiveRate(
      int expectedNumItems, int bitArraySize, int hashFunctions) {
    final probabilityOfZero =
        pow(1 - 1 / bitArraySize, hashFunctions * expectedNumItems);
    return pow(1 - probabilityOfZero, hashFunctions).toDouble();
  }

  /// Returns an index within the range of the bit array size.
  int _generateHash(String element, int hashSeed) {
    return (element.hashCode + hashSeed * 31) % bitArraySize;
  }

  /// Adds an element to the Bloom Filter by setting the bits at the indices
  /// generated by the hash functions.
  void add(String element) {
    for (int i = 0; i < hashFunctions; i++) {
      final hashIndex = _generateHash(element, i);
      final byteIndex = hashIndex ~/ 8;
      final bitIndex = hashIndex % 8;
      bitArray[byteIndex] |= (1 << bitIndex);
    }
  }

  /// Checks if an element is possibly present in the Bloom Filter.
  /// Returns `true` if the element might be present,
  /// `false` if it is definitely absent.
  bool contains(String element) {
    for (int i = 0; i < hashFunctions; i++) {
      final hashIndex = _generateHash(element, i);
      final byteIndex = hashIndex ~/ 8;
      final bitIndex = hashIndex % 8;
      if ((bitArray[byteIndex] & (1 << bitIndex)) == 0) {
        return false;
      }
    }
    return true;
  }
}
