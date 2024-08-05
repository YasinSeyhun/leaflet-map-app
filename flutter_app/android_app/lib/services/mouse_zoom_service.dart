import 'package:flutter/gestures.dart';
import 'package:flutter_map/flutter_map.dart';

class MouseZoomService {
  final MapController mapController;

  MouseZoomService({required this.mapController});

  void onScroll(PointerScrollEvent event) {
    // Zoom seviyesini mouse tekerleği hareketine göre ayarlıyoruz.
    if (event.scrollDelta.dy > 0) {
      // Scroll aşağıya doğruysa zoom out
      mapController.move(mapController.center, mapController.zoom - 1);
    } else {
      // Scroll yukarıya doğruysa zoom in
      mapController.move(mapController.center, mapController.zoom + 1);
    }
  }
}
