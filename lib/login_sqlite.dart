import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './sqluser_model.dart';
//import 'package:sunday//api.dart';
import './database_helper.dart';

class LoginViaSqLite extends StatefulWidget {
  @override
  _LoginViaSqLiteState createState() => _LoginViaSqLiteState();
}

class _LoginViaSqLiteState extends State<LoginViaSqLite> {
 
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  DatabaseHelper db;

  bool _isLoading = false;

  Future<SqlUser> _loginUser(String email, String password) async {
    //fill our db with dummy data
    SqlUser saveUser = SqlUser.fromMap({
      email: "support@inducesmile.com",
      password: "inducesmile",
    });
    await db.saveUser(saveUser).then((val) async {
      if (val == 1) {
        SqlUser user = await db.loginUser(email, password);

        return user;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Login using SQLite")),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Login"),
                    color: Colors.red,
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      SqlUser user = await _loginUser(
                          _emailController.text, _passwordController.text);
                      setState(() => _isLoading = false);

                      if (user != null) {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new LoginScreen(
                            user: user,
                          );
                        }));
                      } else {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Wrong email or")));
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({@required this.user});

  final SqlUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: Center(
        child: user != null
            ? Text("Logged IN \n \n Email: ${user.email} ")
            : Text("Yore not Logged IN"),
      ),
    );
  }
}