import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Scroll eventleri için gerekli
import 'package:flutter_app/controllers/map_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_app/controllers/marker_controller.dart';
import 'package:flutter_app/models/marker_model.dart';
import 'package:flutter_app/views/marker_list.dart';
import 'package:flutter_app/views/wms_view.dart';
import 'package:flutter_app/views/map_marker.dart';
import 'package:flutter_app/services/mouse_zoom_service.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  final MarkerController markerController = Get.put(MarkerController());
  late final CustomMapController customMapController;
  late final MouseZoomService mouseZoomService;
  final RxBool isWmsLayer1Active = false.obs;
  final RxBool isWmsLayer2Active = false.obs;

  @override
  void initState() {
    super.initState();
    customMapController = CustomMapController(tickerProvider: this);
    mouseZoomService =
        MouseZoomService(mapController: customMapController.mapController);
  }

  void toggleWmsLayer1() {
    isWmsLayer1Active.value = !isWmsLayer1Active.value;
  }

  void toggleWmsLayer2() {
    isWmsLayer2Active.value = !isWmsLayer2Active.value;
  }

  @override
  Widget build(BuildContext context) {
    final MapMarkerLayer mapMarkerLayer =
        MapMarkerLayer(mapController: customMapController.mapController);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Map App'),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: MarkerList(mapController: customMapController.mapController),
        body: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              mouseZoomService.onScroll(event);
            }
          },
          child: Stack(
            children: [
              Obx(
                () => FlutterMap(
                  mapController: customMapController.mapController,
                  options: MapOptions(
                    center: LatLng(41.0082, 28.9784),
                    zoom: 10.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                    onTap: (tapPosition, latlng) async {
                      final newMarker = MarkerModel(
                        id: markerController.markers.length,
                        lat: latlng.latitude,
                        lng: latlng.longitude,
                        name: 'Marker ${markerController.markers.length}',
                      );

                      await markerController.addMarker(newMarker);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    if (isWmsLayer1Active.value)
                      TileLayer(
                        wmsOptions: WmsView.wmsLayer1,
                      ),
                    if (isWmsLayer2Active.value)
                      TileLayer(
                        wmsOptions: WmsView.wmsLayer2,
                      ),
                    MarkerLayer(
                      markers: mapMarkerLayer
                          .createMarkers(markerController.markers),
                    ),
                    mapMarkerLayer.buildPopupMarkerLayerWidget(),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'zoomIn',
                      mini: true,
                      child: const Icon(Icons.zoom_in),
                      onPressed: customMapController.zoomIn,
                    ),
                    const SizedBox(height: 5),
                    FloatingActionButton(
                      heroTag: 'zoomOut',
                      mini: true,
                      child: const Icon(Icons.zoom_out),
                      onPressed: customMapController.zoomOut,
                    ),
                    const SizedBox(height: 5),
                    FloatingActionButton(
                      heroTag: 'Wms1',
                      mini: true,
                      child: const Icon(Icons.layers),
                      onPressed: toggleWmsLayer1,
                    ),
                    const SizedBox(height: 5),
                    FloatingActionButton(
                      heroTag: 'Wms2',
                      mini: true,
                      child: const Icon(Icons.layers),
                      onPressed: toggleWmsLayer2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
