import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:flutter_app/models/marker_model.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:get/get.dart';
import 'package:flutter_app/controllers/marker_controller.dart';
import 'package:latlong2/latlong.dart';

class MapMarkerLayer {
  final MapController mapController;
  final PopupController popupController = PopupController();
  final MarkerController markerController = Get.put(MarkerController());

  MapMarkerLayer({required this.mapController});

  List<Marker> createMarkers(List<MarkerModel> markers) {
    MarkerModel? previousMarker;

    return markers.map((marker) {
      final color = getMarkerColor(marker, previousMarker);
      previousMarker =
          marker; // Bir sonraki iterasyon için referans markerı güncelliyoruz.
      return Marker(
        width: 80.0,
        height: 80.0,
        point: latlong2.LatLng(marker.lat, marker.lng),
        builder: (ctx) => GestureDetector(
          onTap: () {
            popupController.showPopupsOnlyFor([
              Marker(
                point: latlong2.LatLng(marker.lat, marker.lng),
                builder: (ctx) => Container(),
              ),
            ]);
          },
          child: Icon(
            Icons.location_on,
            color: color,
            size: 40.0,
          ),
        ),
      );
    }).toList();
  }

  Color getMarkerColor(MarkerModel marker, MarkerModel? previousMarker) {
    if (previousMarker == null) {
      return Colors.green; // İlk marker için varsayılan renk
    }

    final distance = const latlong2.Distance().as(
      latlong2.LengthUnit.Kilometer,
      latlong2.LatLng(previousMarker.lat, previousMarker.lng),
      latlong2.LatLng(marker.lat, marker.lng),
    );

    if (distance < 500) {
      return Colors.green;
    } else if (distance >= 500 && distance < 1000) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  PopupMarkerLayerWidget buildPopupMarkerLayerWidget() {
    return PopupMarkerLayerWidget(
      options: PopupMarkerLayerOptions(
        markers: createMarkers(markerController.markers),
        popupController: popupController,
        markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
        popupDisplayOptions: PopupDisplayOptions(
          builder: (BuildContext context, Marker marker) {
            final markerModel = markerController.markers.firstWhere(
              (m) =>
                  m.lat == marker.point.latitude &&
                  m.lng == marker.point.longitude,
              orElse: () => MarkerModel(id: 0, lat: 0, lng: 0, name: ''),
            );
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${markerModel.name}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
