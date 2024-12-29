class Location {
  final String name;
  final double lat;
  final double lng;

  const Location({required this.name, required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> map) {
    return Location(
      name: map['name'] as String,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
    };
  }
}
