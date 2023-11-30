import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Geolocation extends StatefulWidget {
  const Geolocation({Key? key}) : super(key: key);

  @override
  State<Geolocation> createState() => _GeolocationState();
}

class _GeolocationState extends State<Geolocation> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  String _currentAdress = "";

  Future<Position> _getCurrentLocation() async{
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if(!servicePermission) {
      print("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }


    return await Geolocator.getCurrentPosition();
  }
  _getAdressFromCoordinates() async{
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentLocation!.latitude,_currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAdress = "${place.locality},${place.country}";
      });
    } catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Get User Location"),
        centerTitle: true,
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Location Coordinates',style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 6,
          ),
          Text("Latitude =${_currentLocation?.latitude} ; Longitude =${_currentLocation?.longitude}"),


          SizedBox(height: 30,
          ),
          Text("Location Address",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),),

          SizedBox(height: 6,),
          Text("${_currentAdress}"),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: ()async{

            _currentLocation=await _getCurrentLocation();
            _getAdressFromCoordinates();
            print("${_currentLocation}");
            print("${_currentAdress}");
          }, child: Text("Get Location"))
        ],
      ),),
    );
  }
}
