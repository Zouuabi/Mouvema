import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
///
Map a = {
  'place_id': 152954880,
  'osm_type': 'way',
  'osm_id': 200236544,
  'lat': 34.8856361,
  'lon': 9.201943,
  'class': 'highway',
  'type': 'unclassified',
  'place_rank': 26,
  'importance': 0.10000009999999993,
  'addresstype': 'road',
  'display_name':
      'سيدي علي بن عون, معتمدية سيدي علي بن عون, ولاية سيدي بوزيد, تونس',
  'address': {
    'county': 'سيدي علي بن عون',
    'state_district': ' معتمدية سيدي علي بن عون',
    'state': ' ولاية سيدي بوزيد'
  }
};

class PositionGeocoding {
  static Future<String> reverseGeocode(LatLng point) async {
    final String osmUrl =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&accept-language=fr';
    try {
      final response = await http.get(Uri.parse(osmUrl));
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        String state = decodedJson['address']['state'];
        String city = decodedJson['address']['state_district'];

        String address =
            '${state.substring(12, state.length)} ,${city.substring(10, city.length)}';
        return address;
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  static Future<LatLng> geocode(String locationName) async {
    final String encodedLocation = Uri.encodeComponent(locationName);
    final String osmUrl =
        'https://nominatim.openstreetmap.org/search?q=$encodedLocation&format=json-language=en-US';
    try {
      final response = await http.get(Uri.parse(osmUrl));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        if (decodedJson.isNotEmpty) {
          double latitude = double.parse(decodedJson[0]['lat']);
          double longitude = double.parse(decodedJson[0]['lon']);
          return LatLng(latitude, longitude);
        } else {
          return const LatLng(
              0, 0); // Default coordinates if location not found
        }
      } else {
        return const LatLng(0, 0); // Default coordinates on error
      }
    } catch (e) {
      return const LatLng(0, 0); // Default coordinates on exception
    }
  }
}
