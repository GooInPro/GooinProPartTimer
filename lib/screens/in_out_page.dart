import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gooinpro_parttimer/utils/geolocation_util.dart';


class in_out_page extends StatefulWidget {
  @override
  in_outState createState() => in_outState();
}

class in_outState extends State<in_out_page> {
  Position? _position;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    Position? position = await geolocation_util.getCurrentLocation();
    if(mounted) {
      setState(() {
        _position = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(_position != null)
              Column(
                children: [
                  Text("위도: ${_position!.latitude} 경도: ${_position!.longitude}")
                ],
              )
            else
              CircularProgressIndicator(),
          ],
        )
      )
    );
  }
}

