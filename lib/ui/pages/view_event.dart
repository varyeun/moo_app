import 'package:flutter/material.dart';
import 'package:moo_app/model/event.dart';


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

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Note details'),
        backgroundColor: HexColor("#abc0e1"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(event.eventDate.hour.toString() +
                ":" +
                event.eventDate.minute.toString(), style: TextStyle(fontSize: 16.0,color: Colors.blueGrey)),
            SizedBox(height: 10.0),
            Text(event.description, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 15.0),
            event.imgURL.length>0 ? Image.network(event.imgURL):new Container(),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}