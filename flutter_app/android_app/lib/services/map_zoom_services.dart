import 'package:flutter/animation.dart';
import 'package:flutter_map/flutter_map.dart';

class MapZoomService {
  final MapController mapController;
  final TickerProvider tickerProvider;

  MapZoomService({
    required this.mapController,
    required this.tickerProvider,
  });

  Future<void> animateZoom(double targetZoom,
      {Duration duration = const Duration(milliseconds: 500)}) async {
    final startZoom = mapController.zoom;
    final AnimationController controller = AnimationController(
      duration: duration,
      vsync: tickerProvider, // `TickerProvider` kullanımı.
    );

    final Animation<double> zoomAnimation = Tween<double>(
      begin: startZoom,
      end: targetZoom,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    controller.addListener(() {
      mapController.move(mapController.center, zoomAnimation.value);
    });

    await controller.forward();
    controller.dispose();
  }
}
