
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: gps(),
    );
  }
}

class gps extends StatefulWidget {
  const gps({Key? key}) : super(key: key);

  @override
  State<gps> createState() => _gpsState();
}

class _gpsState extends State<gps> {
  var _latitude="";
  var _longitude="";
  var _altitude="";
  var _speed="";
  var _address="";

  Future<void> _updatePosition() async{
    Position pos=await _determinePosition();
    List pm=await placemarkFromCoordinates(pos.latitude,pos.longitude);
    setState(() {
      _latitude=pos.latitude.toString();
      _longitude=pos.longitude.toString();
      _altitude=pos.altitude.toString();
      _speed=pos.speed.toString();
      _address=pm[0].toString();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPS LOCATION"),
      ),
    body: Center(
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your last Location is:",
      style: TextStyle(
          fontSize: 20
      ),),
          Text("Latitude:"+_latitude,
          style: TextStyle(
           fontSize: 20
          ),),

        Text("Longitute:"+_longitude,
        style: TextStyle(
        fontSize: 20
    ),),

        Text("altitude:"+_altitude,
        style: TextStyle(
        fontSize: 20
    ),),

        Text("Speed:"+_speed,
        style: TextStyle(
        fontSize: 20
    ),
          ),

    Text("Address:",style: TextStyle(
        fontSize: 20
    )),
          Text(_address,style: TextStyle(
              fontSize: 20
          )),





        ],
      ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updatePosition,
        tooltip: 'GPS LOCATION',
        child: Icon(Icons.change_circle_outlined),
      )
    );
  }
}
