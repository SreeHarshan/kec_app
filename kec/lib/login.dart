import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

import 'colors.dart' as colors;
import 'signup.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

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

  void _submit() {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.

    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter details correctly'),
        backgroundColor: Colors.red,
      ));
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
        body: Center(
          child: Container(
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
                                  builder: (context) => const SignupPage()));
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
          ),
        ));
  }

  @override
  void dispose() {
//    _rollno.dispose();
//    _pass.dispose();
    super.dispose();
  }
}
