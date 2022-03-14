import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/controller/encrypter.dart';
import 'package:password_manager/icons_map.dart' as CustomIcons;

class Passwords extends StatefulWidget {
  @override
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends State<Passwords> {
  Box box = Hive.box('passwords');
  bool longPressed = false;
  EncryptService _encryptService = new EncryptService();
  Future fetch() async {
    if (box.values.isEmpty) {
      return Future.value(null);
    } else {
      return Future.value(box.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Your Passwords",
          style: TextStyle(
            fontFamily: "customFont",
            fontSize: 22.0,
          ),
        ),
      ),
      //
      floatingActionButton: FloatingActionButton(
        onPressed: insertDB,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        backgroundColor: Color(0xff892cdc),
      ),
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      //
      body: FutureBuilder(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text(
                "You have saved no password 😓.\nSave some... \nIt's Secure 🔐.\nEverything is in your Phone..",
                style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: "customFont",
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map data = box.getAt(index);
                return Card(
                  margin: EdgeInsets.all(
                    12.0,
                  ),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                      tileColor: Color(0xff1c1c1c),
                      leading: CustomIcons.icons[data['type']] ??
                          Icon(
                            Icons.lock,
                            size: 32.0,
                          ),
                      title: Text(
                        "${data['nick']}",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: "customFont",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "CLick on the copy icon to copy your Password !",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "customFont",
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _encryptService.copyToClipboard(
                            data['password'],
                            context,
                          );
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 36.0,
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () {},
                      ),
                      IconSlideAction(
                        closeOnTap: true,
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void insertDB() {
    String type;
    String nick;
    String email;
    String password;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Container(
          padding: EdgeInsets.all(
            12.0,
          ),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Service",
                    hintText: "Google",
                  ),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "customFont",
                  ),
                  onChanged: (val) {
                    type = val;
                  },
                  validator: (val) {
                    if (val.trim().isEmpty) {
                      return "Enter A Value !";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nick Name",
                    hintText: "Will be dispplayed as a Title",
                  ),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "customFont",
                  ),
                  onChanged: (val) {
                    nick = val;
                  },
                  validator: (val) {
                    if (val.trim().isEmpty) {
                      return "Enter A Value !";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username/Email/Phone",
                  ),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "customFont",
                  ),
                  onChanged: (val) {
                    email = val;
                  },
                  validator: (val) {
                    if (val.trim().isEmpty) {
                      return "Enter A Value !";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "customFont",
                  ),
                  onChanged: (val) {
                    password = val;
                  },
                  validator: (val) {
                    if (val.trim().isEmpty) {
                      return "Enter A Value !";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    // encrypt
                    password = _encryptService.encrypt(password);
                    // insert into db
                    Box box = Hive.box('passwords');
                    // insert
                    var value = {
                      'type': type.toLowerCase(),
                      'nick': nick,
                      'email': email,
                      'password': password,
                    };
                    box.add(value);

                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "customFont",
                    ),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 50.0,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xff892cdc),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
