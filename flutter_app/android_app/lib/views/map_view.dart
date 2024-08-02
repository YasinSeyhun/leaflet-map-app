import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart' as mapbox_gl;
import 'package:flutter_app/controllers/marker_controller.dart';
import 'package:flutter_app/models/marker_model.dart';
import 'package:flutter_app/views/marker_list.dart';
import 'package:flutter_app/views/map_marker.dart';
// import 'package:flutter_api/views/wms_view.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MarkerController markerController = Get.put(MarkerController());
  late mapbox_gl.MapboxMapController mapController;
  // late WmsView wmsView;
  // bool isWmsLayer1Visible = false;
  // bool isWmsLayer2Visible = false;

  void _onMapCreated(mapbox_gl.MapboxMapController controller) {
    mapController = controller;
    // wmsView = WmsView(mapController: mapController);
    markerController.fetchMarkers().then((_) {
      _addMarkersToMap();
    });

    mapController.onSymbolTapped.add((symbol) {
      final marker = markerController.markers.firstWhere(
        (m) =>
            m.lat == symbol.options.geometry?.latitude &&
            m.lng == symbol.options.geometry?.longitude,
        orElse: () => MarkerModel(id: 0, lat: 0, lng: 0, name: 'Bilinmeyen'),
      );
      _showPopup(mapbox_gl.LatLng(marker.lat, marker.lng), marker.name);
    });
  }

  void _addMarkersToMap() {
    MapMarkerLayer(mapController: mapController)
        .addMarkers(markerController.markers.toList());
  }

  void _showPopup(mapbox_gl.LatLng position, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(name),
          content:
              Text('Marker at (${position.latitude}, ${position.longitude})'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  // void _toggleWmsLayer1() {
  //   if (isWmsLayer1Visible) {
  //     wmsView.removeWmsLayer1();
  //   } else {
  //     wmsView.addWmsLayer1();
  //   }
  //   setState(() {
  //     isWmsLayer1Visible = !isWmsLayer1Visible;
  //   });
  // }

  // void _toggleWmsLayer2() {
  //   if (isWmsLayer2Visible) {
  //     wmsView.removeWmsLayer2();
  //   } else {
  //     wmsView.addWmsLayer2();
  //   }
  //   setState(() {
  //     isWmsLayer2Visible = !isWmsLayer2Visible;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Harita Uygulaması'),
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
        endDrawer: MarkerList(mapController: mapController),
        body: Stack(
          children: [
            mapbox_gl.MapboxMap(
              accessToken:
                  'pk.eyJ1IjoieWFzaW5zZXlodW4iLCJhIjoiY2x6ODdtdWRxMDA0ODJqc2E2a2VydDI0ciJ9.IdHBjwPvdXmkYrybjQmyYw',
              onMapCreated: _onMapCreated,
              initialCameraPosition: const mapbox_gl.CameraPosition(
                target: mapbox_gl.LatLng(41.0082, 28.9784), // İstanbul
                zoom: 10.0,
              ),
              onMapClick: (point, coordinates) async {
                final newMarker = MarkerModel(
                  id: markerController.markers.length,
                  lat: coordinates.latitude,
                  lng: coordinates.longitude,
                  name: 'Marker ${markerController.markers.length}',
                );

                await markerController.addMarker(newMarker);
                MapMarkerLayer(mapController: mapController)
                    .addMarkers([newMarker]);
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'zoomIn',
                    child: const Icon(Icons.zoom_in),
                    onPressed: () {
                      mapController
                          .animateCamera(mapbox_gl.CameraUpdate.zoomIn());
                    },
                  ),
                  const SizedBox(height: 5),
                  FloatingActionButton(
                    heroTag: 'zoomOut',
                    child: const Icon(Icons.zoom_out),
                    onPressed: () {
                      mapController
                          .animateCamera(mapbox_gl.CameraUpdate.zoomOut());
                    },
                  ),
                  const SizedBox(height: 5),
                  // FloatingActionButton(
                  //   heroTag: 'toggleWmsLayer1',
                  //   child: const Icon(Icons.layers),
                  //   onPressed: _toggleWmsLayer1,
                  // ),
                  // const SizedBox(height: 5),
                  // FloatingActionButton(
                  //   heroTag: 'toggleWmsLayer2',
                  //   child: const Icon(Icons.layers_clear),
                  //   onPressed: _toggleWmsLayer2,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
