import 'package:firebase_helpers/firebase_helpers.dart';

class EventModel extends DatabaseItem{
  final String id;
  final String description;
  final DateTime eventDate;
  final String imgURL;

  EventModel({this.id, this.description, this.eventDate, this.imgURL}):super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
      description: data['description'],
      eventDate: data['event_date'],
      imgURL: data['imgURL'],

    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      description: data['description'],
      eventDate: data['event_date'].toDate(),
      imgURL: data['imgURL'],
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "description": description,
      "event_date":eventDate,
      "imgURL": imgURL,
      "id":id,
    };
  }
}