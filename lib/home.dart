import 'package:application/loginpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
//import 'package:geolocator/geolocator.dart';

class homePage extends StatefulWidget {
  final dynamic data;
  final String token;
  final String user_id;
  const homePage(
      {required this.data, required this.token, required this.user_id});

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Timer? timer;
  var response;
  //late Position _currentPosition;
  void initState() {
    super.initState();
    response = widget.data;
    timer = Timer.periodic(
        Duration(seconds: 10000), (Timer t) => {UpdateCoordinates()});
  }

  Widget build(BuildContext context) {
    final _name = TextEditingController();
    final _address = TextEditingController();
    final _phone = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange, width: 5)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Current Task',
                            style: TextStyle(
                                fontSize: 33, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      textfieldcustomized("Name", _name),
                      textfieldcustomizedmap("Address", _address),
                      textfieldcustomizedphone("Phone", _phone),
                      Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        'From: Krihna Ojha Ojha Bhawan Civil Lines, Jaipur',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ))),
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          fixedSize: Size(40, 40)),
                                      onPressed: () {
                                        postnotification();
                                      },
                                      child: Text('Status')))
                            ],
                          )),
                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Upcoming Task',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Container(
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        padding: EdgeInsets.all(15),
                        child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Text('Tilak Nagar, Bikaner',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Icon(Icons.arrow_downward),
                                        Text('MP Colony , Bikaner',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )),
                                Expanded(
                                    child: ElevatedButton(
                                  child: Text('Start'),
                                  onPressed: () {
                                    postnotification();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      fixedSize: Size(40, 40)),
                                ))
                              ],
                            )))
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Container textfieldcustomized(
      String label, TextEditingController _controller) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        height: 70,
        child: Center(
          child: TextFormField(
            style: TextStyle(fontWeight: FontWeight.bold),
            obscureText: false,
            initialValue: response["first_name"] + ' ' + response["last_name"],
            //controller: _controller,
            //initialValue: widget.data!["Name"],
            decoration: InputDecoration(
              filled: true,
              labelText: label,
              fillColor: Colors.white,
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(),
              ),
            ),
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ));
  }

  Container textfieldcustomizedphone(
      String label, TextEditingController _controller) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        height: 70,
        child: Center(
          child: TextFormField(
            style: TextStyle(fontWeight: FontWeight.bold),
            obscureText: false,
            initialValue: response["phone_number"],
            //controller: _controller,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.black,
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              suffixIcon: IconButton(
                icon: Icon(Icons.call, color: Colors.black),
                onPressed: () {
                  //Move to the dialer with th number as specified
                  launch('tel:+91${response["phone_number"]}');
                },
              ),
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(),
              ),
            ),
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ));
  }

  Container textfieldcustomizedmap(
      String label, TextEditingController _controller) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        height: 70,
        child: Center(
          child: TextFormField(
            style: TextStyle(fontWeight: FontWeight.bold),
            obscureText: false,
            //controller: _controller,
            initialValue: "Muesuem Circle, Bikaner",
            decoration: InputDecoration(
              isDense: true,
              labelText: label,
              labelStyle: TextStyle(color: Colors.black),
              focusColor: Colors.black,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.map,
                  color: Colors.black,
                ),
                onPressed: () {
                  //Move to the dialer with th number as specified
                  _launchMap();
                },
              ),
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(),
              ),
            ),
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ));
  }

  //Launch map using url_launcher
  _launchMap() async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=' +
            response["address"]["latitude"].toString() +
            ',' +
            response["address"]["longitude"].toString();
    print(googleMapsUrl);

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw "Couldn't launch URL";
    }
  }

  //Update te coordiantes after every few minutes
  UpdateCoordinates() {
    //_getCurrentLocation();
  }

  // _getCurrentLocation() {
  //   Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.best,
  //           forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //       print(_currentPosition);
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  //POST the Notifiactions
  postnotification() async {
    var data = {"user_id": widget.user_id};
    var url =
        "https://pacific-fjord-71880.herokuapp.com/users/sendNotification";
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'X-Auth-Token': widget.token,
        },
        body: json.encode(data));
    var result = json.decode(response.body);
    print(result);
  }
}
