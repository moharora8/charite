// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import '../Widgets/customTextField.dart';
import 'package:place_picker/place_picker.dart';
import '../Config/config.dart';
import '../Widgets/customAppBar.dart';
import '../modals/address.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Config/config2.dart' as c;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../globals.dart' as globals;

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _cName = TextEditingController();

  final _cPhoneNumber = TextEditingController();

  final _cFlatNumber = TextEditingController();

  final _cArea = TextEditingController();

  final _clandmark = TextEditingController();

  final _cCity = TextEditingController();

  final _cState = TextEditingController();
  GeoFirePoint position;
  String result;
  final _cPincode = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;

  String _currentAddress = '';

  final geo = Geoflutterfire();
  double x;
  double y;
  LocationResult result2;
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            //AIzaSyCUn2WOlys4CRGTNxEyK4fd_UIa7XbBCFs
            PlacePicker("AIzaSyBxD2_Z_ocwyuGrdEZxKTXH1BZt86dPVK8")));
    //print(result.latLng);
    print(result.latLng.latitude);
    print(result.latLng.longitude);
    setState(() {
      result2 = result;
      myLocation2 = geo.point(
          latitude: result.latLng.latitude, longitude: result.latLng.longitude);
      globals.user_string = result2.formattedAddress;
      globals.pqrs = myLocation2;
      x = result.latLng.latitude;
      y = result.latLng.longitude;
    });
    // Handle the result in your way
    print(result);
  }

  GeoFirePoint myLocation;
  GeoFirePoint myLocation2;
  // PickResult selectedPlace;

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
      print(myLocation.data);
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
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          key: scaffoldKey,
          appBar: MyAppBar(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (formKey.currentState.validate() && (x != null && y != null)) {
                // final model = AddressModel(
                //         name: _cName.text,
                //         state: _cState.text,
                //         pincode: _cPincode.text,
                //         phoneNumber: _cPincode.text,
                //         landmark: _clandmark.text,
                //         flatNumber: _cFlatNumber.text,
                //         city: _cCity.text,
                //         area: _cArea.text)
                //     .toJson();
                setState(() {
                  globals.abcd = myLocation;
                  // print(globals.abcd.geoPoint);
                  print(globals.abcd.geoPoint.latitude.toString());
                  print(globals.abcd.geoPoint.longitude.toString());
                  //globals.abcd['geopoint']
                });
                CharityApp.firestore
                    .collection(CharityApp.collectionUser)
                    .document(CharityApp.sharedPreferences
                        .getString(CharityApp.userUID))
                    .collection(CharityApp.subCollectionAddress)
                    .document(DateTime.now().millisecondsSinceEpoch.toString())
                    .setData({
                  'name': _cName.text,
                  'state': _cState.text,
                  'pincode': _cPincode.text,
                  'phoneNumber': _cPhoneNumber.text,
                  'landmark': _clandmark.text,
                  'flatNumber': _cFlatNumber.text,
                  'city': _cCity.text,
                  'area': _cArea.text,
                  'location_string': result2.formattedAddress,
                  'position':
                      //'',
                      //myLocation.data
                      myLocation2.data,
                }, merge: true).then((_) {
                  final snackbar =
                      SnackBar(content: Text('Address added successfully'));
                  // ignore: deprecated_member_use
                  scaffoldKey.currentState.showSnackBar(snackbar);
                  FocusScope.of(context).requestFocus(FocusNode());
                  formKey.currentState.reset();
                  Navigator.pop(context);
                });
              } else if (formKey.currentState.validate() &&
                  (x == null && y == null)) {
                Fluttertoast.showToast(msg: 'Please Pick a Place');
              }
            },
            label: Text('Done'),
            backgroundColor: c.primaryColor,
            // Colors.deepPurple,
            icon: Icon(Icons.check),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add address',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextField(
                          type1: TextInputType.text,
                          data: Icons.person_outline,
                          controller: _cName,
                          hintText: 'Name',
                          isObsecure: false,
                        ),
                        // MyTextField(
                        //   hint: 'Name',
                        //   controller: _cName,
                        // ),
                        CustomTextField(
                          maxlength: 10,
                          type1: TextInputType.number,
                          data: Icons.person_outline,
                          controller: _cPhoneNumber,
                          hintText: 'Phone Number',
                          isObsecure: false,
                        ),
                        // MyTextField(
                        //   hint: 'Phone Number',
                        //   max_len: 10,
                        //   controller: _cPhoneNumber,
                        // ),
                        CustomTextField(
                          type1: TextInputType.text,
                          data: Icons.person_outline,
                          controller: _cFlatNumber,
                          hintText: 'Flat Number',
                          isObsecure: false,
                        ),
                        // MyTextField(
                        //   hint: 'Flat Number',
                        //   controller: _cFlatNumber,
                        // ),
                        CustomTextField(
                          type1: TextInputType.text,
                          data: Icons.person_outline,
                          controller: _cArea,
                          hintText: 'Area',
                          isObsecure: false,
                        ),
                        // MyTextField(
                        //   hint: 'Area',
                        //   controller: _cArea,
                        // ),
                        CustomTextField(
                          type1: TextInputType.text,
                          data: Icons.person_outline,
                          controller: _clandmark,
                          hintText: 'Landmark',
                          isObsecure: false,
                        ),
                        // MyTextField(
                        //   hint: 'Landmark',
                        //   controller: _clandmark,
                        // ),
                        CustomTextField(
                          type1: TextInputType.text,
                          data: Icons.person_outline,
                          controller: _cCity,
                          hintText: 'City',
                          isObsecure: false,
                        ),
                        // MyTextField(
                        //   hint: 'City',
                        //   controller: _cCity,
                        // ),
                        CustomTextField(
                          type1: TextInputType.text,
                          data: Icons.person_outline,
                          controller: _cState,
                          hintText: 'State',
                          isObsecure: false,
                        ),
                        // MyTextField(
                        //   hint: 'State',
                        //   controller: _cState,
                        // ),
                        CustomTextField(
                          maxlength: 6,
                          type1: TextInputType.number,
                          data: Icons.person_outline,
                          controller: _cPincode,
                          hintText: 'Pincode',
                          isObsecure: false,
                        ),
                        // MyTextField(
                        //   hint: 'Pincode',
                        //   controller: _cPincode,
                        //   max_len: 6,
                        // ),
                        RaisedButton(
                          onPressed: () {
                            showPlacePicker();
                            //_currentAddress
                            // setState(() {
                            //   x = _currentPosition.latitude;
                            //   y = _currentPosition.latitude;
                            // });
                          },
                          child: Text('Pick a place'),
                        )
                        //
                      ],
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Location',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      //if (result2 != null)
                                      //Text(_currentAddress),
                                      if (result2 != null)
                                        Text('${result2.formattedAddress}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final int max_len;
  final TextEditingController controller;

  const MyTextField({Key key, this.hint, this.controller, this.max_len})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        maxLength: max_len != null ? max_len : null,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (value) => value.isEmpty ? 'Field can\'t be blank' : null,
      ),
    );
  }
}
