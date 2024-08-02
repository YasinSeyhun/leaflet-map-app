class MarkerModel {
  final int id;
  final double lat;
  final double lng;
  String name;

  MarkerModel({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) {
    return MarkerModel(
      id: json['id'],
      lat: json['lat'],
      lng: json['lng'],
      name: json['marker_adi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
      'marker_adi': name,
    };
  }
}
