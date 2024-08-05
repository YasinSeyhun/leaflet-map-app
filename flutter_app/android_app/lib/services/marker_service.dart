import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/models/marker_model.dart';

class MarkerService {
  final String apiUrl = 'http://10.0.2.2:3000/api';

  Future<List<MarkerModel>> fetchMarkers() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/getMarkers'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        return data.map((json) => MarkerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load markers');
      }
    } catch (e) {
      print("Error fetching markers: $e");
      throw e;
    }
  }

  Future<void> addMarker(MarkerModel marker) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/addMarker'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(marker.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add marker');
      }
    } catch (e) {
      print("Error adding marker: $e");
      throw e;
    }
  }

  Future<void> updateMarker(MarkerModel marker) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/updateMarker'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(marker.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update marker');
      }
    } catch (e) {
      print("Error updating marker: $e");
      throw e;
    }
  }

  Future<void> deleteMarker(double lat, double lng) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/deleteMarker'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'lat': lat, 'lng': lng}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete marker');
      }
    } catch (e) {
      print("Error deleting marker: $e");
      throw e;
    }
  }
}
