import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  var _formkey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _lastname = TextEditingController();
  final _phonenumber = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _passwordcheck = TextEditingController();

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
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Form(
              key: _formkey,
              child: ListView(
                children: [
                  textfieldcustomized('First Name', _name),
                  textfieldcustomized('Last Name', _lastname),
                  textfieldcustomized('Phone Number', _phonenumber),
                  textfieldcustomized('UserName', _username),
                  textfieldcustomized('Password', _password),
                  textfieldcustomized('Email', _email),
                  textfieldcustomized('Password Check', _passwordcheck),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            print('pressed');
                            registerUser(
                                _name.text,
                                _lastname.text,
                                _email.text,
                                _password.text,
                                _username.text,
                                _phonenumber.text,
                                _passwordcheck.text);
                          }
                          // if (_formkey.currentState!.validate()) {
                          //   if (_password.toString() ==
                          //       _passwordcheck.toString()) {
                          //     print('registeruser called');
                          //     registerUser(
                          //         _name.text,
                          //         _lastname.text,
                          //         _email.text,
                          //         _password.text,
                          //         _username.text,
                          //         _phonenumber.text,
                          //         _passwordcheck.text);
                          //   }
                          // }
                          ,
                          child: Text('SIGN UP'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange[400],
                            fixedSize: Size(350, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                          )))
                ],
              ),
            )));
  }

  Container textfieldcustomized(
      String label, TextEditingController _controller) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        height: 70,
        child: Center(
          child: TextFormField(
            obscureText: false,
            controller: _controller,
            decoration: InputDecoration(
              labelText: label,
              fillColor: Colors.white,
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
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          ),
        ));
  }

  registerUser(String firstName, String lastName, String email, String password,
      String username, String phoneNumber, String passwordcheck) async {
    Map<String, String> data = {
      "email": email,
      "password": password,
      "passwordCheck": passwordcheck,
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "phone_number": phoneNumber
    };
    print(data);
    var response = await http.post(
        "https://pacific-fjord-71880.herokuapp.com/users/register",
        headers: {"Content-Type": "application/json"},
        body: json.encode(data));
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => homePage(
                data: data,
                token: result["token"],
                user_id: result["user"]["_id"],
              )));
    }
  }
}
