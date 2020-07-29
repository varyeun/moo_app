import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:moo_app/main.dart';

void main() {
  runApp(MaterialApp(
    home: ToMoo(),
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

class ToMoo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    var fam = parser.emojify(':man-woman-girl-boy:');

    return MaterialApp(
        title: "Moo's Coffee Mix",
        home: Scaffold(
          //backgroundColor: HexCo#ablor("c0d1"),
          body: Center(
            child: Container(
              padding: new EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "당근, 다깡, 배추가\n무에게  " + fam,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  ClipRRect(
                      borderRadius: new BorderRadius.circular(10.0),
                      child: Column(
                        children: <Widget>[
                          Image(
                            image: AssetImage('images/dang.jpeg'),
                            fit: BoxFit.fitWidth,
                          ),
                          Image(
                            image: AssetImage('images/i.jpeg'),
                            fit: BoxFit.fitWidth,
                          ),
                          Image(
                            image: AssetImage('images/chu.jpeg'),
                            fit: BoxFit.fitWidth,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: HexColor("#abc0e1"),
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MooApp()));
            },
          ),
        ));
  }
}
