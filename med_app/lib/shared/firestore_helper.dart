import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_app/models/event_detail.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future addNewEvent(EventDetail eventDetail) {
    var result = db
        .collection('event_details')
        .add(eventDetail.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  static Future<List<EventDetail>> getDetailsList() async {
    List<EventDetail> details = [];
    var data = await FirestoreHelper.db.collection('event_details').get();
    if (data != null) {
      details =
          data.docs.map((document) => EventDetail.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
    });
    return details;
  }

  static Future<List<EventDetail>> deleteEvent(String documentId) async {
    await db.collection('event_details').doc(documentId).delete();
    return getDetailsList();
  }
}
