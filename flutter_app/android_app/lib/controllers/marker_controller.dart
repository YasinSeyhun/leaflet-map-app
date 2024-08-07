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
      showSuccessMessage('Markerlar databaseden başarıyla çekildi.');
    } catch (e) {
      showErrorMessage('Markerlar databaseden çekilirken hata oluştu.');
    }
  }

  Future<void> addMarker(MarkerModel marker) async {
    try {
      await _markerService.addMarker(marker);
      markers.add(marker);
      showSuccessMessage('Marker başarıyla eklendi.');
    } catch (e) {
      print("Error adding marker: $e");
      showErrorMessage('Marker eklenirken hata oluştu.');
    }
  }

  Future<void> updateMarker(MarkerModel marker) async {
    try {
      await _markerService.updateMarker(marker);
      fetchMarkers();
      showSuccessMessage('Marker başarıyla güncellendi.');
    } catch (e) {
      print("Error updating marker: $e");
      showErrorMessage('Marker güncellenirken hata oluştu.');
    }
  }

  Future<void> deleteMarker(double lat, double lng) async {
    try {
      await _markerService.deleteMarker(lat, lng);
      fetchMarkers();
      showSuccessMessage('Marker başarıyla silindi.');
    } catch (e) {
      print("Error deleting marker: $e");
      showErrorMessage('Marker silinirken hata oluştu.');
    }
  }

  void showSuccessMessage(String message) {
    print(message);
  }

  void showErrorMessage(String message) {
    print(message);
  }
}
