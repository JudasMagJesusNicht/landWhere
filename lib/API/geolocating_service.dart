import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatingService extends StatefulWidget {
  const GeolocatingService({Key? key}) : super(key: key);

  @override
  State<GeolocatingService> createState() => _GeolocatingServiceState();
}

class _GeolocatingServiceState extends State<GeolocatingService> {

  var _latitude = "";
  var _longitude = "";
  var _altitude = "";
  var _adress = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
  Future<void> _updatePosition() async {
    Position position = await _determinePosition();
    List pm =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      _altitude = position.altitude.toString();

      _adress = pm[0].toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
