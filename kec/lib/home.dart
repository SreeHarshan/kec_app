import 'package:flutter/material.dart';

import 'colors.dart' as colors;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                margin: const EdgeInsets.all(15.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Test",
                      style: TextStyle(
                        color: Color(0xffcacaca),
                        fontSize: 23,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
                            'Home',
                            style: TextStyle(color: colors.foreground),
                          ),
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ))));
  }
}
