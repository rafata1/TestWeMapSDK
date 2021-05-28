import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/Widgets/progressDialog.dart';
import 'package:rider_app/main.dart';

class registerationScreen extends StatelessWidget {
  static const String idScreen = 'register';

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Đang đăng ký, vui lòng chờ...",
          );
        });
    final User? firebaseUser = (await _auth
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: errMsg);
    }))
        .user;
    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid);
      Map userDataMap = {
        'name': name.text.trim(),
        'email': email.text.trim(),
        'phone': phone.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      Fluttertoast.showToast(msg: 'Đăng ký thành công');
      Navigator.pushNamed(context, MainScreen.idScreen);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Đăng ký không thành công");
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
                'Đăng ký tài khoản',
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
                      controller: name,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Họ và tên',
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
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
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
                            'Đăng ký',
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
                        if (name.text.length < 4) {
                          Fluttertoast.showToast(msg: 'Nhập đầy đủ họ và tên');
                        } else if (!email.text.contains('@')) {
                          Fluttertoast.showToast(msg: 'Email sai');
                        } else if (phone.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Số điện thoại là bắt buộc');
                        } else if (password.text.length < 6) {
                          Fluttertoast.showToast(
                              msg: 'Mật khẩu phải từ 6 kí tự trở lên');
                        } else {
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                child: Text(
                  'Đã có tài khoản? Đăng nhập ngay!',
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
