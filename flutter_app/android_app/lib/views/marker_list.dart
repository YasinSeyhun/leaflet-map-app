import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_app/controllers/marker_controller.dart';

class MarkerList extends StatelessWidget {
  final MapController mapController;

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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Obx(() {
                final markers = markerController.markers;
                return ListView.builder(
                  itemCount: markers.length,
                  itemBuilder: (context, index) {
                    final marker = markers[index];
                    double distance = 0;
                    if (index > 0) {
                      final previousMarker = markers[index - 1];
                      distance = const Distance().as(
                        LengthUnit.Kilometer,
                        LatLng(previousMarker.lat, previousMarker.lng),
                        LatLng(marker.lat, marker.lng),
                      );
                    }
                    return ListTile(
                      title: Text(marker.name),
                      subtitle: Text('${distance.toStringAsFixed(2)} km'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  TextEditingController nameController =
                                      TextEditingController(text: marker.name);
                                  return AlertDialog(
                                    title: Text('Marker Güncelle'),
                                    content: TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          labelText: 'Marker İsmi'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('İptal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          marker.name = nameController.text;
                                          markerController.updateMarker(marker);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Kaydet'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              markerController.deleteMarker(
                                  marker.lat, marker.lng);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.location_on, color: Colors.green),
                            onPressed: () {
                              mapController.move(
                                LatLng(marker.lat, marker.lng),
                                13.0, // Zoom level
                              );
                              Navigator.of(context).pop(); // Drawer'ı kapat
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
