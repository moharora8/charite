import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  final geo = Geoflutterfire();
  GeoFirePoint myLocation;
  //final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      myLocation = geo.point(
          latitude: _currentPosition.latitude,
          longitude: _currentPosition.longitude);
      Placemark place = p[0];
// 'position': myLocation.data
      setState(() {
        _currentAddress =
            "${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Location',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          if (_currentPosition != null &&
                              _currentAddress != null)
                            Text(_currentAddress,
                                style: Theme.of(context).textTheme.bodyText2),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ],
            ))
      ],
    );
  }
}
