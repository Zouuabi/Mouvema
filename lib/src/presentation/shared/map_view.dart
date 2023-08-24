// ignore_for_file: depend_on_referenced_packages

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'
    show FlutterMap, MapController, MapOptions, Marker, MarkerLayer, TileLayer;

import 'package:latlong2/latlong.dart';

// ignore: must_be_immutable
class MapView extends StatefulWidget {
  MapView({
    super.key,
    required this.onchange,
    required this.size,
  });
  final Size size;
  final void Function(LatLng?, LatLng?)? onchange;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  LatLng? origin;
  LatLng? destination;
  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.teal, width: 2)),
          width: double.infinity,
          height: widget.size.height * 0.4,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onLongPress: (tapPosition, point) {
                if (origin != null &&
                    _isSameLocation(point, origin!, _mapController.zoom)) {
                  setState(() {
                    markers.removeAt(0);
                    origin = null;
                  });
                } else if (destination != null &&
                    _isSameLocation(point, destination!, _mapController.zoom)) {
                  setState(() {
                    markers.removeLast();
                    destination = null;
                  });
                } else if (origin == null) {
                  setState(() {
                    origin = point;
                    markers.insert(
                        0,
                        marker(
                            point,
                            const Icon(
                              Icons.arrow_circle_up_outlined,
                              color: Color.fromARGB(255, 5, 206, 105),
                            )));
                  });
                } else if (destination == null) {
                  setState(() {
                    destination = point;
                    markers.insert(
                        1,
                        marker(
                            point,
                            const Icon(
                              Icons.arrow_circle_up_outlined,
                              color: Color.fromARGB(255, 206, 31, 5),
                            )));
                  });
                }
                widget.onchange!(origin, destination);
              },
              center: const LatLng(35.6784, 10.0982),
              zoom: 5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: markers)
            ],
          ),
        ),
        Positioned(
            bottom: 10,
            left: widget.size.width * 0.4,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: (origin != null && destination != null)
                  ? Text(
                      '${_calculateDistance(LatLng(origin!.latitude, origin!.longitude), LatLng(destination!.latitude, destination!.longitude)).toString().substring(0, 4)} km',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                    )
                  : const Text('00.00'),
            ))
      ],
    );
  }

  Marker marker(LatLng point, Icon markerIcon) {
    return Marker(
      point: LatLng(point.latitude, point.longitude),
      builder: (context) {
        return markerIcon;
      },
    );
  }

  double _calculateDistance(LatLng latLng1, LatLng latLng2) {
    const double earthRadius = 6371.0;

    double lat1 = latLng1.latitude;
    double lon1 = latLng1.longitude;
    double lat2 = latLng2.latitude;
    double lon2 = latLng2.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  bool _isSameLocation(LatLng location1, LatLng location2, double zoom) {
    double markerTolerance;
    if (zoom < 10) {
      markerTolerance = 0.1;
    } else {
      markerTolerance = 0.01;
    }

    return (location1.latitude - location2.latitude).abs() < markerTolerance &&
        (location1.longitude - location2.longitude).abs() < markerTolerance;
  }
}
