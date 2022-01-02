import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_app/screens/login_screen.dart';
import 'package:med_app/shared/authentication.dart';
import 'package:med_app/shared/firestore_helper.dart';
import '../models/event_detail.dart';
import 'package:uuid/uuid.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Authentication auth = Authentication();
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((result) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: EventList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final List<String> result = await createAlertDialog(context);
          if (result.length > 0) {
            EventDetail newEvent = EventDetail(Uuid().v1(), result[0],
                result[1], result[2], result[3], result[4], result[5]);
            FirestoreHelper.addNewEvent(newEvent);
          }
        },
      ),
    );
  }

  Future<List<String>> createAlertDialog(BuildContext context) async {
    List<String> result = [];
    List<TextEditingController> _controllers =
        List.generate(6, (_) => TextEditingController());

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New Event"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _controllers[0],
                  decoration: InputDecoration(hintText: 'Description'),
                ),
                TextField(
                  controller: _controllers[1],
                  decoration: InputDecoration(hintText: 'Date'),
                ),
                TextField(
                  controller: _controllers[2],
                  decoration: InputDecoration(hintText: 'Start Time'),
                ),
                TextField(
                  controller: _controllers[3],
                  decoration: InputDecoration(hintText: 'End Time'),
                ),
                TextField(
                  controller: _controllers[4],
                  decoration: InputDecoration(hintText: 'Speaker'),
                ),
                TextField(
                  controller: _controllers[5],
                  decoration: InputDecoration(hintText: 'Is Favorite'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(result);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _controllers.forEach((element) {
                  result.add(element.text);
                });
                Navigator.of(context).pop(result);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<EventDetail> details = [];

  @override
  void initState() {
    if (mounted) {
      FirestoreHelper.getDetailsList().then((data) {
        setState(() {
          details = data;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, position) {
          EventDetail currentEvent = details[position];
          String description = currentEvent.description;
          String date = currentEvent.date;
          String startTime = currentEvent.startTime;
          String endTime = currentEvent.endTime;
          String subTitle = 'Date: $date - Start: $startTime - End: $endTime';
          return Dismissible(
            key: Key(currentEvent.id),
            onDismissed: (direction) {
              FirestoreHelper.deleteEvent(currentEvent.id).then((data) {
                details = data;
                setState(() {
                  details.removeAt(position);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("${currentEvent.description} dismissed")),
                );
              });
            },
            background: Container(
              color: Colors.red,
            ),
            child: ListTile(
              title: Text(description),
              subtitle: Text(subTitle),
            ),
          );
        });
  }
}
