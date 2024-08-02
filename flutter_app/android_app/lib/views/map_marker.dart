import 'dart:ui';
import 'package:mapbox_gl/mapbox_gl.dart' as mapbox_gl;
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:flutter_app/models/marker_model.dart';

class MapMarkerLayer {
  final mapbox_gl.MapboxMapController mapController;

  MapMarkerLayer({required this.mapController});

  void addMarkers(List<MarkerModel> markers) {
    for (var marker in markers) {
      _addMarker(marker);
    }
  }

  void _addMarker(MarkerModel marker) {
    double distance = const latlong2.Distance().as(
      latlong2.LengthUnit.Kilometer,
      latlong2.LatLng(41.0082, 28.9784), // İstanbul
      latlong2.LatLng(marker.lat, marker.lng),
    );

    String color;
    if (distance < 500) {
      color = "green";
    } else if (distance >= 500 && distance < 1000) {
      color = "orange";
    } else {
      color = "red";
    }

    mapController.addSymbol(mapbox_gl.SymbolOptions(
      geometry: mapbox_gl.LatLng(marker.lat, marker.lng),
      iconImage: "marker-15",
      iconSize: 1.5,
      textField: marker.name,
      textOffset: const Offset(0, 2),
      textSize: 12.0,
      textColor: color,
    ));
  }
}
