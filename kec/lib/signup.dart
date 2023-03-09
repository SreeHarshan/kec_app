// ignore: import_of_legacy_library_into_null_safe
import 'package:validate/validate.dart';
import 'package:flutter/material.dart';

import 'colors.dart' as colors;
import 'global_vars.dart' as global;
import 'dart:convert' as convert;
import 'package:http/http.dart' as HTTP;

bool isDigit(String s) {
  return int.tryParse(s) != null;
}

class SignupPage extends StatefulWidget {
  final Function() notifyParent;
  const SignupPage({Key? key, required this.notifyParent}) : super(key: key);

  @override
  _signup createState() => _signup();
}

// ignore: camel_case_types
class _signup extends State<SignupPage> {
  // ignore: non_constant_identifier_names
  String email = "", pass = "", confim_pass = "", name = "", rollno = "";
  bool _done = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _validateEmail(String? value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(value);
    } catch (e) {
      _done = false;
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      _done = false;
      return 'The Password must be at least 8 characters.';
    }
    pass = value;
    return null;
  }

  String? _validateConfirmPass(String? value) {
    if (value! != pass) {
      _done = false;
      return "The password does not match";
    }
  }

  String? _validaterollno(String? value) {
    if (value!.length != 8) {
      return 'The rollno should be valid';
    }
    String s1, s2, s3;
    s1 = value.substring(0, 2);
    s2 = value.substring(2, 5);
    s3 = value.substring(5);
    if (isDigit(s1) && isDigit(s3) && s2.contains(RegExp(r'[A-Z]'))) {
      pass;
    } else {
      _done = false;
      return 'Enter rollno properly';
    }
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

  void _senderror() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please enter details correctly'),
      backgroundColor: Colors.red,
    ));
  }

  Future<void> _submit() async {
    // First validate form.
    _done = true;
    if (_formKey.currentState!.validate() && _done) {
      _formKey.currentState!.save();

      try {
        var url = Uri.parse("http://127.0.0.1:8000/api/signup/");
        buildShowDialog(context);
        var response = await HTTP.post(url, body: {
          'rollno': rollno,
          'email': email,
          'password': pass,
          'name': name
        });
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        global.login = jsonResponse['login'];
        if (global.login) {
          global.rollno = rollno;
          global.name = name;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Registered successfully'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('There was an error registering'),
            backgroundColor: Colors.red,
          ));
        }
        Navigator.pop(context);
      } on Exception catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('There was an issue registering in'),
          backgroundColor: Colors.red,
        ));
      }

      widget.notifyParent();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      _senderror();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
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
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                const Text(
                  "Register",
                  style: TextStyle(
                    color: colors.foreground,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'YY(DEPT)NO',
                        labelText: 'Roll Number'),
                    validator: _validaterollno,
                    onSaved: (String? value) {
                      rollno = value!;
                    }),
                const SizedBox(height: 10),
                TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                        labelText: 'Name'),
                    onSaved: (String? value) {
                      name = value!;
                    }),
                const SizedBox(height: 5),
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
                const SizedBox(height: 5),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        labelText: "Re-enter your paswword"),
                    validator: _validateConfirmPass,
                    onSaved: (String? value) {
                      confim_pass = value!;
                    }),
                const SizedBox(height: 5),
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
                        'Register',
                        style: TextStyle(color: colors.foreground),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
