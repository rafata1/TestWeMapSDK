import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registerationScreen.dart';
import 'package:rider_app/Widgets/progressDialog.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loginAuth(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Đang xác thực, vui lòng chờ...",
          );
        });
    final User? firebaseUser = (await _auth
            .signInWithEmailAndPassword(
                email: email.text, password: password.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: errMsg);
    }))
        .user;
    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamed(context, MainScreen.idScreen);
          Fluttertoast.showToast(msg: 'Đăng nhập thành công');
        } else {
          Navigator.pop(context);

          _auth.signOut();
          Fluttertoast.showToast(msg: 'Tài khoản không tồn tại');
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Không thể đăng nhập");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 35.0,
              ),
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: 390.0,
                height: 250.0,
              ),
              SizedBox(height: 1.0),
              Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.black,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        loginAuth(context);
                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                child: Text(
                  'Không có tài khoản? Đăng ký ngay!',
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, registerationScreen.idScreen, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
