import 'dart:convert';

import 'package:flutter/material.dart';
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

  // User input City to grab API data from
  final _cityTextController = TextEditingController();


  // Necessary variables
  var cityName;
  var name;
  var lat;
  var lon;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var airPressure;

  var currentPosition;




  // Method that teste if location services are enabled. If not it opens window on phone
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;


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

 void _getCurrentPosition() async{
   Position? position = await Geolocator.getLastKnownPosition();
   print(position);
   setState(() {
     currentPosition = position;
     lat = position?.latitude.toString();
     lon = position?.longitude.toString();
   });
  }
  @override
  void initState(){
    super.initState();
    _getCurrentPosition();

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
              // Bar on Top to decide how to grab API data
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
                        _getCurrentPosition();
                        getWeatherByCoordinates(lat,lon);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      child: const Icon(Icons.location_searching),
                    ),
                  ],
                ),Container(
                  margin: EdgeInsets.all(30),
                  child: Text(
                    name != null ? name.toString()  : 'Loading',
                    style: GoogleFonts.rubikMonoOne(
                        color: Colors.black, fontSize: 50),
                        textAlign: TextAlign.center,
                  ),
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
              //ListView displaying certain weather infos to the screen
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.thermostat,
                      color: Colors.black45,
                    ),
                    title: Text(
                      'Luftdruck',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45, fontSize: 12),
                    ),
                    trailing: Text(
                      airPressure != null ? airPressure.toString() + 'hPa'  : 'Loading',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.water_drop_outlined,
                      color: Colors.black45,
                    ),
                    title: Text(
                      'Luftfeuchtigkeit',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45, fontSize: 12),
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
                      'Wind Geschwindigkeit',
                      style: GoogleFonts.rubikMonoOne(color: Colors.black45, fontSize: 12),
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
  // Method that uses user input to load OpenWeatherMap API data
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
      this.name = results['name'];
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.airPressure = results['main']['pressure'];

    });
  }
  // Method that uses user coordinates to load OpenWeatherMap API data
  Future getWeatherByCoordinates(String lat, String lon) async {

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
      this.name = results['name'];
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.airPressure = results['main']['pressure'];
    });
  }

}
