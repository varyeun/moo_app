import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moo_app/record.dart';
import 'package:moo_app/tomoo.dart';
import 'package:moo_app/info.dart';

void main() {
  runApp(MaterialApp(
    home: MooApp(),
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

class MooApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    var heart = parser.emojify(':purple_heart:');
    var fl1 = parser.emojify(':cherry_blossom:');
    var fl2 = parser.emojify(':blossom:');

    return MaterialApp(

        title: "Moo's Coffee Mix",
        home: Scaffold(
          //backgroundColor: HexColor("#abc0e1"),
          body: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Image.asset('assets/coffeeimg.png'),
                  FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MooRecord()));
                      },
                      padding: EdgeInsets.all(25),
                      shape: CircleBorder(),
                      child: Image(
                        image: AssetImage('images/coffeeimg.png'),
                        fit: BoxFit.cover,
                        height: 200,
                      )),
                  SizedBox(height: 10),
                  Text(
                    fl1 + " Moo's Coffee Mix History " + fl2,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  Padding(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: Text(
                        "지니가 만든 이곳에서\n무는 무가 마신 믹스커피에 대해\n기록할 수 있습니다. " +
                            heart +
                            "\n\n기록을 시작하려면\n위의 커피를 터치해 주세요!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ),
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size:22.0),
            //visible: _dialVisible,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            backgroundColor: HexColor("#abc0e1"),
            foregroundColor: Colors.white,
            elevation: 8.0,
            shape: CircleBorder(),
            children:[
              SpeedDialChild(
                  backgroundColor: HexColor("#b0c5c6"),
                  child: Icon(Icons.favorite),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ToMoo()));
                  }
              ),
              SpeedDialChild(
                  backgroundColor: HexColor("#b0c5c6"),
                  child: Icon(Icons.info_outline),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Info()));
                  }
              ),
            ]
          )
            /*
          floatingActionButton: FloatingActionButton(
            backgroundColor: HexColor("#b0c5c6"),
            child: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ToMoo()));
            },
          ),

             */
        ));
  }
}
