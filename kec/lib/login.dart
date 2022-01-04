import 'package:flutter/material.dart';

import 'colors.dart' as colors;
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  _loginpage createState() => _loginpage();
}

// ignore: camel_case_types
class _loginpage extends State<LoginPage> {
  late TextEditingController _rollno, _pass;
  @override
  void initState() {
    super.initState();
    _rollno = TextEditingController();
    _pass = TextEditingController();
  }

  void _login() {
    if (_rollno.text.isNotEmpty && _pass.text.isNotEmpty) {
      //TODO login here
      Navigator.pop(context);
    } else {
      /*
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Incorrect Values"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Retry"))
                ],
              ));*/

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter details correctly'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
          child: Container(
              margin: const EdgeInsets.all(15.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.green)),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Login/Sign Up",
                    style: TextStyle(
                      color: colors.foreground,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10), // to add padding

                  TextField(
                    controller: _rollno,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Roll No',
                    ),
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 1), // to add padding

                  TextField(
                    controller: _pass,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 10), // to add padding

                  GestureDetector(
                    onTap: _login,
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
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()));
                      },
                      child: const Text("New User? Register",
                          style: TextStyle(color: Colors.grey)))
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ))),
    );
  }

  @override
  void dispose() {
    _rollno.dispose();
    _pass.dispose();
    super.dispose();
  }
}
