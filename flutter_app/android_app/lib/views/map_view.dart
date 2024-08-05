import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/map_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_app/controllers/marker_controller.dart';
import 'package:flutter_app/models/marker_model.dart';
import 'package:flutter_app/views/marker_list.dart';
import 'package:flutter_app/views/wms_view.dart';
import 'package:flutter_app/views/map_marker.dart';

class MapView extends StatelessWidget {
  final MarkerController markerController = Get.put(MarkerController());
  final CustomMapController customMapController = CustomMapController();
  final RxBool isWmsLayer1Active = false.obs;
  final RxBool isWmsLayer2Active = false.obs;

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
          title: Text('Flutter Map App'),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: MarkerList(mapController: customMapController.mapController),
        body: Stack(
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
                    markers:
                        mapMarkerLayer.createMarkers(markerController.markers),
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
                    child: Icon(Icons.zoom_in),
                    onPressed: customMapController.zoomIn,
                  ),
                  SizedBox(height: 5),
                  FloatingActionButton(
                    heroTag: 'zoomOut',
                    mini: true,
                    child: Icon(Icons.zoom_out),
                    onPressed: customMapController.zoomOut,
                  ),
                  SizedBox(height: 5),
                  FloatingActionButton(
                    heroTag: 'Wms1',
                    mini: true,
                    child: Icon(Icons.layers),
                    onPressed: toggleWmsLayer1,
                  ),
                  SizedBox(height: 5),
                  FloatingActionButton(
                    heroTag: 'Wms2',
                    mini: true,
                    child: Icon(Icons.layers),
                    onPressed: toggleWmsLayer2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
