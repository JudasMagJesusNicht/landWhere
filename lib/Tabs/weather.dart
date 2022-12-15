import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;




class Weather extends StatefulWidget {
  const Weather({Key? key, required title}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final String title = 'Weather';

  final _cityTextController = TextEditingController();



  var cityName;
  var lat;
  var lon;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;





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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Container(
                      width: 220,
                      child: TextField(
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                        controller: _cityTextController,
                        decoration: InputDecoration(
                            hintText: 'Gib deinen Ort ein:',
                            hintStyle: GoogleFonts.roboto(color: Colors.black54,fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _cityTextController.clear();
                              },
                              icon: Icon(Icons.clear),
                            )),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getWeatherByCity(_cityTextController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      child: const Icon(Icons.search),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _determinePosition().then((value){
                          lat ='$value.latitude';
                          lon ='$value.longitude';
                        });
                        getWeatherByCoordinates(lat,lon);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      child: const Icon(Icons.location_searching),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  child: Text(
                    temp != null ? temp.toString() + "\u00B0" : 'Loading',
                    style: GoogleFonts.rubikMonoOne(
                        color: Colors.black, fontSize: 40),
                  ),
                ),
                Text(
                  currently != null ? currently.toString() : 'Loading',
                  style: GoogleFonts.rubikMonoOne(
                      color: Colors.black, fontSize: 15),
                ),
              ])
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.thermostat,
                      color: Colors.black45,
                    ),
                    title: Text(
                      'Temperature',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45),
                    ),
                    trailing: Text(
                      temp != null ? temp.toString() + "\u00B0" : 'Loading',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.water_drop_outlined,
                      color: Colors.black45,
                    ),
                    title: Text(
                      'Humidity',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45),
                    ),
                    trailing: Text(
                      humidity != null ? humidity.toString() + '%' : 'Loading',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45),
                    ),
                  ),ListTile(
                    leading: Icon(
                      Icons.wind_power,
                      color: Colors.black45,
                    ),
                    title: Text(
                      'Wind Speed',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45),
                    ),
                    trailing: Text(
                      windSpeed != null ? windSpeed.toString()   : 'Loading',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future getWeatherByCity(String cityName) async {
    final queryParameters = {
      'q': cityName,
      'appid': '54a4320f0228f237495a6df9e9d1cac1',
      'units': 'metric',
    };
    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    http.Response response = await http.get(uri);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  Future getWeatherByCoordinates(double lat, double lon) async {
    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'appid': '54a4320f0228f237495a6df9e9d1cac1',
      'units': 'metric',
    };
    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    http.Response response = await http.get(uri);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

}
