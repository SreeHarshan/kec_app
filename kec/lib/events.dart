import 'package:flutter/material.dart';
import 'colors.dart' as colors;
import 'dart:convert' as convert;
import 'package:http/http.dart' as HTTP;
import 'global_vars.dart' as global;

class Event {
  final String name;
  // ignore: non_constant_identifier_names
  final String org_name;
  final String desc;
  final int id;
  bool hosted, enrolled;
  int count = 0;
  // ignore: non_constant_identifier_names
  List<String> Mname, Mrollno;

  Event(
    this.name,
    this.org_name,
    this.desc,
    this.id,
    this.Mname,
    this.Mrollno, {
    this.hosted = false,
    this.enrolled = false,
    count = 0,
  });

  factory Event.fromMap(Map<String, dynamic> json) {
    return Event(
      json['title'],
      json['organiser'],
      json['description'],
      json['id'],
      json['Mname'],
      json['Mrollno'],
      count: json['count'],
    );
  }

  Future<void> _enroll(BuildContext c) async {
    if (!global.login) {
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(
        content: Text("Login first to enroll in an event"),
        backgroundColor: Colors.red,
      ));
    } else {
      if (hosted) {
        ScaffoldMessenger.of(c).showSnackBar(const SnackBar(
          content: Text("Event host can't enroll in it"),
          backgroundColor: Colors.red,
        ));
      } else {
        var l = [];
        bool api = true;
        for (int i = 0; i <= global.enrolled_events.length - 1; i++) {
          if (global.enrolled_events[i].id == id) {
            ScaffoldMessenger.of(c).showSnackBar(const SnackBar(
              content: Text("Already joined the event"),
              backgroundColor: Colors.red,
            ));
            api = false;
            break;
          } else {
            l.add(global.enrolled_events[i].id.toString());
          }
        }
        if (api) {
          global.enrolled_events.add(this);
          l.add(id.toString());
          var url = Uri.parse("http://127.0.0.1:8000/api/update/");
          var json_inp = {"rollno": global.rollno, "events": l};
          var response = await HTTP.post(url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: convert.jsonEncode(json_inp));
          var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
          if (json['msg']) {
            ScaffoldMessenger.of(c).showSnackBar(const SnackBar(
              content: Text("Successfully enrolled"),
              backgroundColor: Colors.green,
            ));
          } else {
            ScaffoldMessenger.of(c).showSnackBar(const SnackBar(
              content: Text("There was an issue enrolling"),
              backgroundColor: Colors.red,
            ));
          }
        }
      }

      Navigator.pop(c);
    }
  }

  Widget getScaffold(BuildContext context) {
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
          child: Column(
            children: <Widget>[
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: colors.foreground)),
              const SizedBox(height: 10),
              Text("Organized by " + org_name),
              const SizedBox(height: 5),
              Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(desc, softWrap: true)),
              GestureDetector(
                onTap: () {
                  _enroll(context);
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
                      'Enroll',
                      style: TextStyle(color: colors.foreground),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              widget_count(context),
            ],
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Widget widget_count(BuildContext context) {
    if (hosted) {
      return Text("Number of people joined:" + count.toString());
    }
    return const SizedBox(height: 0);
  }

  Widget? members(BuildContext context) {}
}

class EventListItem extends StatefulWidget {
  const EventListItem({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  // ignore: no_logic_in_create_state
  _eventlistitem createState() => _eventlistitem(event: event);
}

// ignore: camel_case_types
class _eventlistitem extends State<EventListItem> {
  _eventlistitem({required this.event});
  Event event;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => event.getScaffold(context)));
        },
        leading: CircleAvatar(
            backgroundColor: colors.foreground, child: Text(event.name[0])),
        title: Text(event.name));
  }
}

class EventsList extends StatefulWidget {
  const EventsList({Key? key}) : super(key: key);

  @override
  eventslist createState() => eventslist();
}

// ignore: camel_case_types
class eventslist extends State<EventsList> {
  // ignore: non_constant_identifier_names
  Widget empty_or_list(BuildContext context) {
    if (global.events.isNotEmpty) {
      return Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: global.events.map((Event event) {
            return EventListItem(event: event);
          }).toList(),
        ),
      );
    }
    return const Center(child: Text("No events available"));
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: _refresh, child: empty_or_list(context)));
    /*   return Scaffold(
        body: FutureBuilder(
      future: global.events,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          late List<Event> list;
          global.events.then((val) => setState(() {
                list = val;
              }));
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: list.map((Event event) {
              return EventListItem(event: event);
            }).toList(),
          );
        }
        return const Center(child: Text("No events available"));
      },
    ));*/
  }
}

class Enrolledevents extends StatefulWidget {
  const Enrolledevents({Key? key}) : super(key: key);

  @override
  _Enrolledeventslist createState() => _Enrolledeventslist();
}

class _Enrolledeventslist extends State<Enrolledevents> {
  Widget empty_or_list(BuildContext context) {
    if (global.enrolled_events.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: global.enrolled_events.map((Event event) {
          return EventListItem(event: event);
        }).toList(),
      );
    }
    return const Center(child: Text("You haven't joined any events"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: empty_or_list(context));
  }
}

class Hostedevents extends StatefulWidget {
  const Hostedevents({Key? key}) : super(key: key);

  @override
  _Hostedeventslist createState() => _Hostedeventslist();
}

class _Hostedeventslist extends State<Hostedevents> {
  void _switchtonewevent() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HostEvent()));
  }

  // ignore: non_constant_identifier_names
  Widget empty_or_list(BuildContext context) {
    if (global.user_events.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: global.user_events.map((Event event) {
          return EventListItem(event: event);
        }).toList(),
      );
    }
    return const Center(child: Text("You haven't hosted any events"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: empty_or_list(context),
      floatingActionButton: FloatingActionButton(
          onPressed: _switchtonewevent,
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          child: const Icon(Icons.add)),
    );
  }
}

class HostEvent extends StatefulWidget {
  const HostEvent({Key? key}) : super(key: key);

  @override
  _hosteventpage createState() => _hosteventpage();
}

// ignore: camel_case_types
class _hosteventpage extends State<HostEvent> {
  String eventname = "", eventdesc = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    _formKey.currentState!.save();
    if (!global.login) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login first to host an event'),
        backgroundColor: Colors.red,
      ));
    } else {
      try {
        var url = Uri.parse("http://127.0.0.1:8000/eventslist/");
        global.buildShowDialog(context);
        var response = await HTTP.post(url, body: {
          'title': eventname,
          'desc': eventdesc,
          'organiser': global.name
        });
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        print(jsonResponse);
        if (jsonResponse['count'] == 0) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Successfully hosted an event'),
            backgroundColor: Colors.green,
          ));
          Event e = Event(
              eventname, global.name, eventdesc, jsonResponse['id'], [], [],
              hosted: true);
          global.user_events.add(e);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Event name already exists'),
            backgroundColor: Colors.red,
          ));
        }
      } on Exception catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('There was an issue hosting an event'),
          backgroundColor: Colors.red,
        ));
      } finally {
        Navigator.pop(context);
      }
    }

    Navigator.pop(context); //Home screen
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
            margin: const EdgeInsets.all(15.0),
            child: Form(
                key: _formKey,
                child: ListView(children: <Widget>[
                  const Text(
                    "Event details",
                    style: TextStyle(
                      color: colors.foreground,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Event Name'),
                      onSaved: (String? value) {
                        eventname = value!;
                      }),
                  const SizedBox(height: 5),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Event description'),
                    onSaved: (String? value) {
                      eventdesc = value!;
                    },
                    minLines: 5,
                    maxLines: 10,
                  ),
                  // ignore: sized_box_for_whitespace
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
                                'Host',
                                style: TextStyle(color: colors.foreground),
                              ),
                            ),
                          ),
                        )
                      ]))
                ]))));
  }
}
