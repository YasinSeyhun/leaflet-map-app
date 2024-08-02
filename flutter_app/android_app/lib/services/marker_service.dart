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
        print("Failed to fetch markers. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching markers: $e");
    }
    return [];
  }

  Future<void> addMarker(MarkerModel marker) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/addMarker'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(marker.toJson()),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        print("Failed to add marker. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding marker: $e");
    }
  }

  Future<void> updateMarker(MarkerModel marker) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/updateMarker'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(marker.toJson()),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        print("Failed to update marker. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating marker: $e");
    }
  }

  Future<void> deleteMarker(double lat, double lng) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/deleteMarker?lat=$lat&lng=$lng'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return;
      } else {
        print("Failed to delete marker. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting marker: $e");
    }
  }
}
