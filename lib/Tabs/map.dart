import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../API/locationService.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<Marker> customMarkers = [] ;
  var markerPosition;
  var markerLat;
  var markerLng;
  var markerTitle;
  var markerSnippet;



  final CollectionReference _mapcoords = FirebaseFirestore.instance.collection('mapcoords');
  final Stream<QuerySnapshot> savedMarkers = FirebaseFirestore.instance.collection('mapcoords').snapshots();


  TextEditingController _searchController = TextEditingController();
  TextEditingController _markerTitleController = TextEditingController();
  TextEditingController _markerSnippetController = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(54.3232927, 10.1227652),
    zoom: 14.4746,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              )),
              IconButton(
                onPressed: () async {
                  var place = await LocationService().getPlace(_searchController.text);
                  _goToPlaceByCity(place);

                },
                icon: Icon(
                    Icons.search,
                    color: Colors.black45,
                ),
              ),
              IconButton(
                onPressed: () async {
                  _goToPlaceByCoords();
                },
                icon: Icon(
                  Icons.location_searching_sharp,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              //markers: Set<Marker>.of(markers.values),
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },

              markers: Set.from(customMarkers),
              onLongPress: _setCustomMarker,

            ),

          ),

        ],
      ),
    );
  }


  // Method that moves camera to desired position
  Future<void> _goToPlaceByCity(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }

  Future<void> _goToPlaceByCoords() async {
    Position? position = await Geolocator.getLastKnownPosition();
    final double? lat = position?.latitude;
    final double? lng = position?.longitude;

    print(lat.toString()+lng.toString());

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat!, lng!), zoom: 12),
    ));
  }

    // Method to set a custom Marker on tapped point including a marker name
   _setCustomMarker(LatLng tappedPoint){
    openDialog();
    setState(() {
      //customMarkers =[];
      markerPosition = tappedPoint;
      markerLat = tappedPoint.latitude;
      markerLng = tappedPoint.longitude;

      markerSnippet = _markerSnippetController.text.toString();
      customMarkers.add(Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
        infoWindow: InfoWindow(
            title: markerTitle,
          snippet: markerSnippet,


        ),
      ));
    }
    );
   }

   // Method to open the dialog for entering a name for point
   Future openDialog() async => showDialog(

       context: context,
       builder: (context) => AlertDialog(
         title: Text('Speichere einen Landeplatz'),
         content: TextFormField(
           controller: _markerTitleController,
           decoration: InputDecoration(
             hintText: 'Name des Landeplatzes',
           ),
         ),
         actions: [
           TextButton(
             child: Text('Speichern'),
             onPressed: submit,
           )
         ],
       )
   );


  // Method to close PopUp and create CustomMarker
  void submit(){
    Navigator.of(context).pop();
    setState(() {
      markerTitle= _markerTitleController.text.toString()!;
    });
    print(markerTitle);
    createCustomMarker();
  }

  //upload CustomMarker to FireStore
  Future createCustomMarker() async{
    final customMarker = FirebaseFirestore.instance.collection('mapcoords').doc();

    final json = {
      'Bezeichnung': markerTitle,
      'Position': GeoPoint(markerLat, markerLng),
    };

    await customMarker.set(json);
  }

}
