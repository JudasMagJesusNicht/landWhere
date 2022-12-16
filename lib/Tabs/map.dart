import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(

            children: [
              Expanded(child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
              )),
              IconButton(
                onPressed: () async {
                  var place = await LocationService().getPlace(_searchController.text);
                  _goToPlace(place);
                },
                icon: Icon(Icons.search),
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

  Stream<List<CustomMarker>> readCustomMarkers() => FirebaseFirestore.instance.collection('mapcoords').snapshots().map((snapshot) => snapshot.docs.map((doc) => CustomMarker.fromJson(doc.data())));

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }

   _setCustomMarker(LatLng tappedPoint){

    openDialog();
    setState(() {
      //customMarkers =[];
      markerPosition = tappedPoint;
      markerLat = tappedPoint.latitude;
      markerLng = tappedPoint.longitude;
      markerTitle= _markerTitleController.text.toString()!;
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
   Future openDialog() => showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Text('Speichere einen Landeplatz'),
         content: TextField(
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

       ));

  void submit(){
    Navigator.of(context).pop();
    print(markerTitle);
    //createCustomMarker();
  }

  Future createCustomMarker() async{
    final customMarker = FirebaseFirestore.instance.collection('mapcoords').doc();

    final json = {
      'Bezeichnung': markerTitle,
      'Position': GeoPoint(markerLat, markerLng),
    };

    await customMarker.set(json);
  }
}
