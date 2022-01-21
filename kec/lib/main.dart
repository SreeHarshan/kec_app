import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

// ignore: library_prefixes
import 'package:http/http.dart' as HTTP;
import 'dart:convert' as convert;
import 'home.dart';
import 'login.dart';
import 'events.dart';
import 'info.dart';
import 'colors.dart' as colors;
import 'global_vars.dart' as global;

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
        home: const Main())));

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
  int _selectedidx = 0;

  final List<Widget> _widgets = [
    const EventsList(),
    const Enrolledevents(),
    const Hostedevents(),
    const infopage()
  ];

  @override
  void initState() {
    super.initState();
    _update_events();
  }

  // ignore: non_constant_identifier_names
  Future<void> _update_events() async {
    global.buildShowDialog(context);
    var url = Uri.parse("http://127.0.0.1:8000/api/events/");
    var response = await HTTP.get(url);
    global.events = await global.parseEvents(response.body);
    print(global.events[0].count);

    //Enrolled events
    if (global.rollno != "") {
      url = Uri.parse("http://127.0.0.1:8000/api/list/");
      response = await HTTP.post(url, body: {"rollno": global.rollno});
      var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> enrolled = json['Data']['event_ids'];
      if (enrolled.isNotEmpty) {
        for (int i = 0; i <= enrolled.length - 1; i++) {
          for (int j = 0; j <= global.events.length - 1; j++) {
            if (enrolled[i] == global.events[j].id) {
              global.enrolled_events.add(global.events[j]);
              global.events[j].enrolled = true;
            }
          }
        }
      }

      //Hosted events
      for (int i = 0; i <= global.events.length - 1; i++) {
        if (global.events[i].org_name == global.name) {
          global.events[i].hosted = true;
          global.user_events.add(global.events[i]);
        }
      }
    } else {
      global.enrolled_events = [];
      global.user_events = [];
    }
    Navigator.pop(context);
  }

  void refresh() {
    _update_events();
    setState(() {});
  }

  void _ontapped(int idx) {
    setState(() {
      _selectedidx = idx;
    });
  }

  String login() {
    if (global.login) {
      return global.rollno;
    }
    return "Login In";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KEC"),
        actions: <Widget>[
          Center(
              child: Text(login(),
                  style:
                      const TextStyle(fontSize: 15, color: colors.foreground))),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                              notifyParent: refresh,
                            )));
              },
              icon: const Icon(Icons.assignment_ind)),
        ],
      ),
      body: _widgets.elementAt(_selectedidx),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Events'),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Enrolled',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Hosted',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        selectedItemColor: colors.focus,
        currentIndex: _selectedidx,
        onTap: _ontapped,
      ),
    );
  }
}
