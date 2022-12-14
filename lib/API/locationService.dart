import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

class LocationService{
  final String keyAPI = 'AIzaSyC2BkhzVpL8sAN-6Uq2m3e5WR_D9pc2Af4';

  Future<String> getPlaceID(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$keyAPI';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;


  }

  //Future<Map<String, dynamic>> getPlace(String input) async {}
}