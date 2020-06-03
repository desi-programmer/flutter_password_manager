import 'package:fltr_password/passwordpage.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Password Manager",
      theme: ThemeData(
        accentColor: dark,
        primaryColor: deeppurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void check() {
    if (formkey.currentState.validate()) {
      print("Validated");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PasswordPage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: Center(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.userLock,
                color: lightpurple,
                size: 100.0,
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: TextFormField(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "ubuntu"),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: lightpurple,
                      labelText: "Enter Password",
                      labelStyle: TextStyle(
                        color: dark,
                      )),
                  validator: (_val) {
                    if (_val == "desi") {
                      return null;
                    } else {
                      return "Password Doesn't Match";
                    }
                  },
                  obscureText: true,
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 10.0,
                ),
                onPressed: check,
                child: Text(
                  "Enter",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "ubuntumedium",
                  ),
                ),
                color: lightpurple,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
