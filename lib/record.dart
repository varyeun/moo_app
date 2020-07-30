import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:moo_app/model/event.dart';
import 'package:moo_app/res/event_firestore_service.dart';
import 'package:moo_app/ui/pages/add_event.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:moo_app/ui/pages/view_event.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  runApp(MaterialApp(
    home: MooRecord(),
  ));
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class MooRecord extends StatefulWidget {
  @override
  _MooRecordState createState() => _MooRecordState();
}

class _MooRecordState extends State<MooRecord> with TickerProviderStateMixin {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedEvents = _selectedEvents;
    _events = _events;
  }

  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    var coffee = parser.emojify(':coffee:');

    return Scaffold(
      appBar: AppBar(
        title: Text(" Moo's Coffee Mix History " + coffee),
        backgroundColor: HexColor("#abc0e1"),
      ),
      body: StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
              }
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  TableCalendar(
                    formatAnimation: FormatAnimation.slide,
                    events: _events,
                    initialCalendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                        todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: 18.0,
                      color: Colors.white,
                    )),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    onDaySelected: (date, events) {
                      setState(() {
                        _selectedEvents = events;
                      });
                    },
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: HexColor("#b0c5c6"),
                            borderRadius: BorderRadius.circular(13.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: HexColor("#abc0e1"),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    calendarController: _controller,
                  ),
                  ..._selectedEvents.map(
                    (event) => Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                        isThreeLine: true,
                        title: Text(event.description),
                        subtitle: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(event.eventDate.hour.toString() +
                                ":" +
                                event.eventDate.minute.toString())),
                         trailing: event.imgURL.length>0 ?
                        new ConstrainedBox(
                           constraints: BoxConstraints(
                             minWidth: 44,
                             minHeight: 44,
                             maxWidth: 64,
                             maxHeight: 64,
                           ),
                           child: Image.network(event.imgURL),
                         )
                         : null,
            onTap: ()
             {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EventDetailsPage(
                                    event: event,
                                  )));
                        },
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            caption: 'Delete',
                            color: Colors.redAccent,
                            icon: Icons.delete,
                            onTap: () => {
                                  eventDBS.removeItem(event.id.toString()),
                                  setState(() {
                                    _selectedEvents.remove(event);
                                    if(event.imgURL.length>0){

                                      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("events/${event.eventDate.toString()}") ;
                                      firebaseStorageRef.delete();
                                    }
                                    _selectedEvents = _selectedEvents;
                                  })
                                })
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: HexColor("#abc0e1"),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddEventPage()));
          }),
    );
  }
}
