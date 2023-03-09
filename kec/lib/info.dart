import 'package:flutter/material.dart';

import 'colors.dart' as colors;

// ignore: camel_case_types
class infopage extends StatefulWidget {
  const infopage({Key? key}) : super(key: key);

  @override
  _info createState() => _info();
}

class _info extends State<infopage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ignore: prefer_const_literals_to_create_immutables
        body: Column(children: <Widget>[
      const Text(
        "About",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: colors.foreground),
      ),
      const SizedBox(height: 5),
      const Padding(
          padding: EdgeInsets.all(32),
          child: Text('''

Kongu Engineering College, one of the foremost multi professional research-led Institutions is internationally a recognized leader in professional and career-oriented education. It provides an integral, inter-disciplinary education - a unique intersection between theory and practice, passion and reason. The College offers courses of study that are on the frontiers of knowledge and it connects the spiritual and practical dimensions of intellectual life, in a stimulating environment that fosters rigorous scholarship and supportive community. This Institute is a great possession of the committed Trust called 'The Kongu Vellalar Institute of Technology Trust' in Erode District, Tamilnadu. The noble Trust has taken the institute to greater heights since its inception in 1983 and has established the college as a forum for imparting value based education for men and women.  ''',
              softWrap: true)),
      const Text("an app by Sree Harshan",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
    ]));
  }
}
