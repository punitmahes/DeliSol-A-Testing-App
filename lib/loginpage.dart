import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'SignUpPage.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final RegExp emailRegex = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            print("Back Button is pressed");
          },
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                  child: Center(
                    child: Container(
                      child: Image.asset('assets/loginimage.png'),
                      alignment: Alignment.center,
                      height: 200,
                      width: 200,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              'Let\'s Sign you in.',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )),
                        Text('Welcome Back.', style: TextStyle(fontSize: 18)),
                        Text('You have been missed!',
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Column(
                  children: [
                    Container(
                        child: Center(
                      child: TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                        validator: (String? value) {
                          if (!emailRegex.hasMatch(value.toString())) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                    )),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Center(
                          child: TextFormField(
                            controller: _password,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  _toggle();
                                },
                              ),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Recover Password',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                      child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            // SIgn Up Button
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignUp()));
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        //Sign In Button
                        ElevatedButton(
                            onPressed: () {
                              String email = '';
                              String password = '';
                              setState(() {
                                email = _email.text;
                                password = _password.text;
                              });
                              FocusScope.of(context).unfocus();
                              signIn(email, password);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange[400],
                              fixedSize: Size(350, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                            ))
                      ],
                    ),
                  )))
            ],
          )),
    );
  }

  signIn(String email, String password) async {
    var data = {'email': email, 'password': password};
    var url = "https://pacific-fjord-71880.herokuapp.com/users/login";
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      getData(result['token'], result['user']['_id']);
    } else {
      print("Please check email and password");
    }
    //putNotification(result['token'], result['user']['_id']);
  }

  getData(String token, String user) async {
    final response = await http
        .get('https://pacific-fjord-71880.herokuapp.com/users/', headers: {
      'Content-Type': 'application/json',
      'X-Auth-Token': token,
    });
    Map<String, dynamic> data = {
      "Name": '',
      "Address": '',
      "Phone": '',
      "latitude": '',
      "longitude": '',
      'token': '',
    };
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      data["Name"] = result["first_name"] + ' ' + result["last_name"];
      data["Phone"] = result["phone_number"];
      data["token"] = token;
      if (data["Name"].toString().isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => homePage(
                  data: result,
                  token: token,
                  user_id: user,
                )));
      }
    } else {
      print("Error in getting data");
    }
  }

  putNotification(String token, String user_id) async {
    Map data = {"token": token, "user_id": user_id};
    var url =
        'https://pacific-fjord-71880.herokuapp.com/users/notificationToken';
    var response = await http.get(url, headers: {"X-Auth-Token": token});
    print(response.statusCode);
  }
}
