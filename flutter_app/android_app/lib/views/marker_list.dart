import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:flutter_app/controllers/marker_controller.dart';
import 'package:mapbox_gl/mapbox_gl.dart' as mapbox_gl;

class MarkerList extends StatelessWidget {
  final mapbox_gl.MapboxMapController mapController;

  MarkerList({required this.mapController});

  @override
  Widget build(BuildContext context) {
    final MarkerController markerController = Get.find();

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'MARKER LIST',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Obx(() {
                final markers = markerController.markers;
                return ListView.builder(
                  itemCount: markers.length,
                  itemBuilder: (context, index) {
                    final marker = markers[index];
                    double distance = const latlong2.Distance().as(
                      latlong2.LengthUnit.Kilometer,
                      latlong2.LatLng(41.0082, 28.9784),
                      latlong2.LatLng(marker.lat, marker.lng),
                    );

                    String distanceText = '';
                    if (index > 0) {
                      final previousMarker = markers[index - 1];
                      distanceText =
                          'Distance: ${distance.toStringAsFixed(2)} km';
                    }

                    return ListTile(
                      title: Text(marker.name),
                      subtitle: Text(distanceText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  TextEditingController nameController =
                                      TextEditingController(text: marker.name);
                                  return AlertDialog(
                                    title: const Text('Marker Güncelle'),
                                    content: TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                          labelText: 'Marker İsmi'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('İptal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          marker.name = nameController.text;
                                          markerController.updateMarker(marker);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Kaydet'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              markerController.deleteMarker(
                                  marker.lat, marker.lng);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.location_on,
                                color: Colors.green),
                            onPressed: () {
                              mapController.animateCamera(
                                  mapbox_gl.CameraUpdate.newLatLngZoom(
                                mapbox_gl.LatLng(marker.lat, marker.lng),
                                13.0,
                              ));
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
