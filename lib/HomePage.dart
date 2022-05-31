import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Position? position;
  String address = "My Address";

  fethPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Fluttertoast.showToast(msg: "Disable");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location Permission is Denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location Permission Denied Forever");
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try{


      List<Placemark> placemarks = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);
      Placemark place = placemarks[0];

      setState((){
        position = currentPosition;
        address = "${place.locality}, ${place.country}";

      }
      );

    }catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("FInd My Location"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "My Location",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      position == null?  "Location": position.toString()),
                  ElevatedButton(
                    onPressed: () {
                      fethPosition();
                    },
                    child: Text("Find Me"),
                  )
                ],
              ),
            )));
  }
}
