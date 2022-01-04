// ignore_for_file: non_constant_identifier_names
import 'package:validate/validate.dart';
import 'package:flutter/material.dart';

import 'colors.dart' as colors;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _signup createState() => _signup();
}

// ignore: camel_case_types
class _signup extends State<SignupPage> {
  String email = "", pass = "", confim_pass = "", name = "", rollno = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  void submit() {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.

    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kongu Engineering College"),
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
                TextFormField(
                    keyboardType: TextInputType
                        .emailAddress, // Use email input type for emails.
                    decoration: const InputDecoration(
                        hintText: 'you@example.com',
                        labelText: 'E-mail Address'),
                    validator: _validateEmail,
                    onSaved: (String? value) {
                      email = value!;
                    }),
                TextFormField(
                    obscureText: true, // Use secure text for passwords.
                    decoration: const InputDecoration(
                        hintText: 'Password', labelText: 'Enter your password'),
                    validator: _validatePassword,
                    onSaved: (String? value) {
                      pass = value!;
                    }),
                Container(
                  width: screenSize.width,
                  child: RaisedButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: submit,
                    color: Colors.blue,
                  ),
                  margin: const EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          ),
        ));
  }
}
