import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_app/services/map_zoom_services.dart';

class CustomMapController {
  final MapController mapController = MapController();
  late final MapZoomService mapZoomService;

  CustomMapController({required TickerProvider tickerProvider}) {
    mapZoomService = MapZoomService(
      mapController: mapController,
      tickerProvider: tickerProvider,
    );
  }

  Future<void> zoomIn() async {
    await mapZoomService.animateZoom(mapController.zoom + 1);
  }

  Future<void> zoomOut() async {
    await mapZoomService.animateZoom(mapController.zoom - 1);
  }
}
