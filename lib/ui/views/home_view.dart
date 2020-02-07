import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kidnaphotspots/ui/views/login_view.dart';
import 'package:kidnaphotspots/viewmodels/home_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:google_maps_webservice/places.dart';

String apiKey = 'API_KEY';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

Geolocator geolocator = Geolocator();

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;

  var currentLocation;

  var clients = [];

  var currentClient;
  var currentBearing;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String error;
  Mode _mode = Mode.overlay;

  GoogleMapController mapController;
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 4.0,
  );

  var distances = [];

  @override
  void initState() {
    Geolocator().getCurrentPosition().then((currLoc) {
      setState(() {
        currentLocation = currLoc;
        mapToggle = true;
        populateClients();
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  populateClients() {
    clients = [];
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          clientsToggle = true;
        });
        for (int i = 0; i < docs.documents.length; ++i) {
          clients.add(docs.documents[i].data);
          initMarker(docs.documents[i].data);
        }
        getDistance();
      }
    });
  }

  getDistance() {
    distances = [];
    for (int i = 0; i < clients.length; ++i) {
      geolocator
          .distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        double.parse(clients[i]['latitude']),
        double.parse(clients[i]['longitude']),
      )
          .then((calDist) {
        distances.add(calDist);
        // setState(() {
        //   distance = calDist;
        // });
        print(calDist / 1000);
        if (calDist / 1000 < 5) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: ListTile(
                    leading: Icon(
                      Icons.report_problem,
                      size: 50.0,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Kidnapping Alert!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: Text(
                    'You need to be very careful in this area.\nTarget: ${clients[i]['address'].toString()}',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      color: Colors.teal,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      }).catchError((e) {
        print(e);
      });
    }

    // setState(() {
    //   distance = dist;
    // });
  }

  initMarker(client) {
    final markerId = MarkerId(client['address']);
    final marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(client['latitude']),
        double.parse(client['longitude']),
      ),
      infoWindow: InfoWindow(title: client['address'], snippet: 'mosh'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
      ),
      draggable: false,
    );
    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  Widget clientCard(client, _image) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentClient = client;
          currentBearing = 90.0;
        });
        zoomInMarker(client);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(_image),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(client['address']),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(
    String address,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            address,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              "4.1",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
            Container(
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                Icons.star_half,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              "(946)",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          'Dangerous area',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        )),
      ],
    );
  }

  zoomInMarker(client) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(double.parse(client['latitude']),
                double.parse(client['longitude'])),
            zoom: 10.0,
            bearing: 90.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        resetToggle = true;
      });
    });
  }

  resetCamera() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 18.0,
    )))
        .then((val) {
      setState(() {
        getDistance();
        resetToggle = false;
      });
    });
  }

  addBearing() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(double.parse(currentClient['latitude']),
                double.parse(currentClient['longitude'])),
            bearing: currentBearing == 360.0
                ? currentBearing
                : currentBearing + 90.0,
            zoom: 14.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        if (currentBearing == 360.0) {
        } else {
          currentBearing = currentBearing + 90.0;
        }
      });
    });
  }

  removeBearing() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(double.parse(currentClient['latitude']),
                double.parse(currentClient['longitude'])),
            bearing:
                currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
            zoom: 14.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        if (currentBearing == 0.0) {
        } else {
          currentBearing = currentBearing - 90.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
          leading: Icon(Icons.location_on),
          title: Text("Kidnap Hotspots"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _handlePressPrediction,
            ),
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(),
                    ));
              },
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 80.0,
                  width: double.infinity,
                  child: mapToggle
                      ? GoogleMap(
                          onMapCreated: onMapCreated,
                          myLocationEnabled: true,
                          initialCameraPosition: _initialCameraPosition,
                          markers: Set<Marker>.of(markers.values),
                        )
                      : Center(
                          child: Text(
                            'Loading... Please wait...\n\n Make sure you turn on your location',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height - 220.0,
                    left: 10.0,
                    child: Container(
                        height: 125.0,
                        width: MediaQuery.of(context).size.width,
                        child: clientsToggle
                            ? ListView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.all(8.0),
                                children: clients.map((element) {
                                  return clientCard(
                                      element, 'assets/images/kidnap2.jpeg');
                                }).toList(),
                              )
                            : Container(height: 1.0, width: 1.0))),
                resetToggle
                    ? Positioned(
                        top: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height - 50.0),
                        right: 15.0,
                        child: FloatingActionButton(
                          onPressed: resetCamera,
                          mini: true,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.refresh),
                        ))
                    : Container(),
                resetToggle
                    ? Positioned(
                        top: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height - 50.0),
                        right: 60.0,
                        child: FloatingActionButton(
                            onPressed: addBearing,
                            mini: true,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.rotate_left)))
                    : Container(),
                resetToggle
                    ? Positioned(
                        top: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height - 50.0),
                        right: 110.0,
                        child: FloatingActionButton(
                            onPressed: removeBearing,
                            mini: true,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.rotate_right)))
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressPrediction() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: apiKey,
        onError: onError,
        mode: _mode,
        language: "en",
        logo: Image.asset(
          '',
          scale: 2000,
        ),
        components: [Component(Component.country, "ng")],
        location: Location(7.548218, 4.566960),
        radius: 500000,
        strictbounds: true);

    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    // final add = detail.result.name;
    LatLng destination = LatLng(lat, lng);

    // final GoogleMapController controller = await _controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: destination,
      zoom: 10,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}
