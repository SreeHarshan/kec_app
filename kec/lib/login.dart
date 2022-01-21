import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:validate/validate.dart';
// ignore: library_prefixes
import 'package:http/http.dart' as HTTP;

import 'colors.dart' as colors;
import 'signup.dart';
import 'global_vars.dart' as global;
import 'dart:convert' as convert;

class LoginPage extends StatefulWidget {
  final Function() notifyParent;
  const LoginPage({Key? key, required this.notifyParent}) : super(key: key);

  @override
  _loginpage createState() => _loginpage();
}

// ignore: camel_case_types
class _loginpage extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "", pass = "";
  String? _validateEmail(String? value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      return 'The Password must be at least 8 characters.';
    }
    return null;
  }

  Future<void> _submit() async {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.

      //Backend
      var url = Uri.parse("http://127.0.0.1:8000/api/login/");
      buildShowDialog(context);
      try {
        var response =
            await HTTP.post(url, body: {"email": email, "password": pass});

        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        global.login = jsonResponse['login'];
        if (!global.login) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please enter details properly'),
            backgroundColor: Colors.red,
          ));
        } else {
          global.rollno = jsonResponse['rollno'];
          global.name = jsonResponse['name'];

          //Get events enrolled
          url = Uri.parse("http://127.0.0.1:8000/api/list/");
          response = await HTTP.post(url, body: {"rollno": global.rollno});
          jsonResponse =
              convert.jsonDecode(response.body) as Map<String, dynamic>;

          Navigator.pop(context);
        }
      }
      // ignore: empty_catches
      on Exception catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('There was an issue logging in'),
          backgroundColor: Colors.red,
        ));
      }

      //TODO update global var called events_enrolled
      widget.notifyParent();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter details correctly'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _logout() {
    global.login = false;
    global.rollno = "";
    global.user_events = [];
    global.enrolled_events = [];

    widget.notifyParent();
    Navigator.pop(context);
  }

  Widget body(BuildContext context) {
    if (global.login) {
      return Column(children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Text("Already logged in as " + global.rollno),
        GestureDetector(
          onTap: _logout,
          child: Container(
            height: 50.0,
            width: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: colors.background,
            ),
            child: const Center(
              child: Text(
                'Log out',
                style: TextStyle(color: colors.foreground),
              ),
            ),
          ),
        )
      ]);
    }
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const Text(
              "Login",
              style: TextStyle(
                color: colors.foreground,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
                keyboardType: TextInputType
                    .emailAddress, // Use email input type for emails.

                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'you@example.com',
                    labelText: 'E-mail Address'),
                validator: _validateEmail,
                onSaved: (String? value) {
                  email = value!;
                }),
            const SizedBox(height: 5),
            TextFormField(
                obscureText: true, // Use secure text for passwords.
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    labelText: 'Enter your password'),
                validator: _validatePassword,
                onSaved: (String? value) {
                  pass = value!;
                }),
            Container(
              width: screenSize.width,
              child: Column(children: <Widget>[
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    height: 50.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: colors.background,
                    ),
                    child: const Center(
                      child: Text(
                        'Log In',
                        style: TextStyle(color: colors.foreground),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // to add padding

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupPage(
                                  notifyParent: widget.notifyParent,
                                )));
                  },
                  child: Container(
                    height: 50.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: colors.background,
                    ),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(color: colors.foreground),
                      ),
                    ),
                  ),
                ),
              ]),
              margin: const EdgeInsets.only(top: 20.0),
            )
          ],
        ),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("KEC"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(child: body(context)));
  }

  @override
  void dispose() {
//    _rollno.dispose();
//    _pass.dispose();
    super.dispose();
  }
}
