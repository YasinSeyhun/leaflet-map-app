import 'package:get/get.dart';
import 'package:flutter_app/models/marker_model.dart';
import 'package:flutter_app/services/marker_service.dart';

class MarkerController extends GetxController {
  var markers = <MarkerModel>[].obs;
  final MarkerService markerService = MarkerService();

  @override
  void onInit() {
    fetchMarkers();
    super.onInit();
  }

  Future<void> fetchMarkers() async {
    final fetchedMarkers = await markerService.fetchMarkers();
    markers.assignAll(fetchedMarkers);
  }

  Future<void> addMarker(MarkerModel marker) async {
    await markerService.addMarker(marker);
    fetchMarkers();
  }

  Future<void> updateMarker(MarkerModel marker) async {
    await markerService.updateMarker(marker);
    fetchMarkers();
  }

  Future<void> deleteMarker(double lat, double lng) async {
    await markerService.deleteMarker(lat, lng);
    fetchMarkers();
  }
}
