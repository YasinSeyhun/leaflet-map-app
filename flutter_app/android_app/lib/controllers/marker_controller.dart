import 'package:get/get.dart';
import 'package:flutter_app/models/marker_model.dart';
import 'package:flutter_app/services/marker_service.dart';

class MarkerController extends GetxController {
  var markers = <MarkerModel>[].obs;
  final MarkerService _markerService = MarkerService();

  @override
  void onInit() {
    fetchMarkers();
    super.onInit();
  }

  Future<void> fetchMarkers() async {
    try {
      markers.value = await _markerService.fetchMarkers();
    } catch (e) {
      print("Error fetching markers: $e");
    }
  }

  Future<void> addMarker(MarkerModel marker) async {
    try {
      await _markerService.addMarker(marker);
      markers.add(marker);
    } catch (e) {
      print("Error adding marker: $e");
    }
  }

  Future<void> updateMarker(MarkerModel marker) async {
    try {
      await _markerService.updateMarker(marker);
      fetchMarkers();
    } catch (e) {
      print("Error updating marker: $e");
    }
  }

  Future<void> deleteMarker(double lat, double lng) async {
    try {
      await _markerService.deleteMarker(lat, lng);
      fetchMarkers();
    } catch (e) {
      print("Error deleting marker: $e");
    }
  }
}
