import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'home.dart';
import 'login.dart';
import 'colors.dart' as colors;

void main() => runApp(DevicePreview(
    enabled: true,
    builder: (context) => MaterialApp(
        title: "Kec",
        /*theme: ThemeData(
          hintColor: colors.focus,
        ),*/
        darkTheme: ThemeData.dark(),
        //themeMode: ThemeMode.system,
        themeMode: ThemeMode.dark,
        home: Main())));

/*
void main() => runApp(MaterialApp(
    title: "Kec",
    /*theme: ThemeData(
          hintColor: colors.focus,
        ),*/
    darkTheme: ThemeData.dark(),
    //themeMode: ThemeMode.system,
    themeMode: ThemeMode.dark,
    home: Main()));
*/
class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _main createState() => _main();
}

// ignore: camel_case_types
class _main extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("KEC"),
          leading: const IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null,
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: const Icon(Icons.assignment_ind))
          ],
        ),
        body: const App());
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
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
        const SizedBox(height: 10), // to add padding
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    )));
  }
}
