import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'events.dart';

//Global vars
bool login = false;
String rollno = "";
String name = "";
//events
List<Event> events = [];
List<Event> user_events = [];
List<Event> enrolled_events = [];

parseEvents(String responseBody) async {
  var json = convert.jsonDecode(responseBody)['data'];
  int i = 0;
  List<Event> e = [];
  //List<String> Mname = [], Mrollno = [];
  while (json.isNotEmpty) {
    e.add(Event.fromMap(json[i.toString()]));
    json.remove(i.toString());
    i++;
  }
  return e;
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
