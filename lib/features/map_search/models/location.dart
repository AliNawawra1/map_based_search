class Location {
  final String name;
  final double latitude;
  final double longitude;

  const Location(
      {required this.name, required this.latitude, required this.longitude});

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      name: map['name'] as String,
      latitude: map['lat'] as double,
      longitude: map['lng'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': latitude,
      'lng': longitude,
    };
  }
}
