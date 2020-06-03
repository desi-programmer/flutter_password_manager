import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dbhelper.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final dbhelper = Databasehelper.instance;
  String type;
  String user;
  String pass;
  var allrows = [];

  TextStyle titlestyle = TextStyle(
    fontSize: 18.0,
    fontFamily: "ubuntu",
    color: Colors.white,
  );

  TextStyle subtitlestyle = TextStyle(
    fontSize: 16.0,
    fontFamily: "ubuntu",
    color: Colors.white70,
  );

  String validateempty(_val) {
    if (_val.isEmpty) {
      return "Required Field";
    } else {
      return null;
    }
  }

  void insertdata() async {
    Navigator.pop(context);
    Map<String, dynamic> row = {
      Databasehelper.columnType: type,
      Databasehelper.columnUser: user,
      Databasehelper.columnPass: pass,
    };
    final id = await dbhelper.insert(row);
    print(id);
    setState(() {});
  }

  Future<void> queryall() async {
    allrows = await dbhelper.queryall();
    // allrows.forEach((row) {
    //   print(row);
    // });
    // print(allrows);
  }

  void addpassword() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              backgroundColor: deeppurple,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              title: Text(
                "Add Data",
                style: titlestyle,
              ),
              children: <Widget>[
                Form(
                  key: formstate,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Select Type",
                          labelStyle: subtitlestyle,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: dark)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: dark)),
                        ),
                        style: titlestyle,
                        validator: validateempty,
                        onChanged: (_val) {
                          type = _val;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Enter Username/Email",
                            labelStyle: subtitlestyle,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: dark)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: dark)),
                          ),
                          style: titlestyle,
                          validator: validateempty,
                          onChanged: (_val) {
                            user = _val;
                          },
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Enter Password",
                          labelStyle: subtitlestyle,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: dark)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: dark)),
                        ),
                        style: titlestyle,
                        validator: validateempty,
                        onChanged: (_val) {
                          pass = _val;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (formstate.currentState.validate()) {
                              print("Ready To Enter Data");
                              insertdata();
                            }
                          },
                          child: Text(
                            "ADD",
                            style: titlestyle,
                          ),
                          color: deeppurple,
                          padding: EdgeInsets.symmetric(
                            horizontal: 35.0,
                            vertical: 10.0,
                          ),
                          elevation: 5.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Saved Passwords",
          style: TextStyle(
            fontFamily: "ubuntumedium",
          ),
        ),
        backgroundColor: dark,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addpassword,
        child: FaIcon(FontAwesomeIcons.plus),
        backgroundColor: deeppurple,
      ),
      backgroundColor: dark,
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasData != null) {
            if (allrows.length == 0) {
              return Center(
                child: Text(
                  "No Data Availabe 😥\nClick On The Add Button To Enter Some !",
                  style: TextStyle(
                    color: lightpurple,
                    fontSize: 25.0,
                    fontFamily: "ubuntumedium",
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Center(
                child: Container(
                  decoration: BoxDecoration(),
                  width: MediaQuery.of(context).size.width * 0.93,
                  child: ListView.builder(
                    itemCount: allrows.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 20.0,
                        ),
                        decoration: BoxDecoration(
                          color: deeppurple,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 10.0,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  allrows[index]['type'],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontFamily: "ubuntumedium",
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: FaIcon(
                                FontAwesomeIcons.userSecret,
                                size: 40.0,
                                color: Colors.white,
                              ),
                              title: Text(
                                allrows[index]['user'],
                                style: titlestyle,
                              ),
                              subtitle: Text(
                                allrows[index]['pass'],
                                style: subtitlestyle,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: queryall(),
      ),
    );
  }
}
