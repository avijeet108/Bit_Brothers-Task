import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_password_login/screen/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool spin = true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedinuser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedinuser = UserModel.fromMap(value.data());
      setState(() {
        spin = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[200],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: spin
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.teal,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Image.asset('images/logo.png'),
                    height: 100,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Hey! Welcome',
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "${loggedinuser.username}",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    "${loggedinuser.email}",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Material(
                    elevation: 15.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                      ),
                      child: TextButton(
                        onPressed: () {
                          logout(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.lime[200],
                              size: 27.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'LogOut',
                                style: TextStyle(
                                    color: Colors.lime[200],
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "Logged out successfully");

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }
}
