import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/pages/passwords.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
  // create a key if doesn't exist
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }
  //
  var encryptionKey = base64Url.decode(await secureStorage.read(key: 'key'));
  print('Encryption key: $encryptionKey');

  var encryptedBox = await Hive.openBox(
    'passwords',
    encryptionCipher: HiveAesCipher(encryptionKey),
  );
  // encryptedBox.put('secret', 'Hive is cool');
  // print(encryptedBox.get('secret'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xff892cdc),
        accentColor: Colors.purpleAccent,
        scaffoldBackgroundColor: Color(0xff151515),
        textTheme: TextTheme().apply(
          fontFamily: "customFont",
        ),
      ),
      home: FingerPrintAuth(),
    );
  }
}

class FingerPrintAuth extends StatefulWidget {
  @override
  _FingerPrintAuthState createState() => _FingerPrintAuthState();
}

class _FingerPrintAuthState extends State<FingerPrintAuth> {
  bool authenticated = false;
  void authenticate() async {
    print("Calling LOG !");
    try {
      var localAuth = LocalAuthentication();
      authenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to show your Passwords',
        biometricOnly: true,
        useErrorDialogs: true,
      );
      if (authenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Passwords(),
          ),
        );
      } else {
        setState(() {});
        print(authenticated);
      }
    } catch (e) {
      if (e.code == "NotAvailable") {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "ERROR",
            ),
            content: Text(
              "You need to setup either PIN or Fingerprint Authentication to be able to use this App !\nI am doing this for your safety 🙂",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                ),
              ),
            ],
          ),
        );
      }
      print(e.code);
    }
  }

  @override
  void initState() {
    authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Auth"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.black54,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: Theme.of(context).primaryColor,
                size: 150.0,
              ),
            ),
            //
            SizedBox(
              height: 15.0,
            ),
            //
            if (!authenticated)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Oh Snap ! You Need to authenticate to move forward.",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontFamily: "keepcalm",
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  //
                  SizedBox(
                    height: 15.0,
                  ),
                  //
                  TextButton(
                    onPressed: () {
                      authenticate();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Try Again",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        //
                        SizedBox(
                          width: 5.0,
                        ),
                        //
                        Icon(
                          Icons.replay_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
