import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:moo_app/main.dart';

void main() {
  runApp(MaterialApp(
    home: Info(),
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

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    var coffee = parser.emojify(':coffee:');
    var yheart = parser.emojify(':yellow_heart:');
    var dog = parser.emojify(':dog:');
    var me = parser.emojify(':female-office-worker:');
    return MaterialApp(
        title: "Moo's Coffee Mix",
        home: Scaffold(
          //backgroundColor: HexColor("#abc0e1"),
          body: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Image.asset('assets/coffeeimg.png'),
                  //SizedBox(height: 10),
                  Text(
                    "Moo\'s Coffee Mix History "+yheart+"\n\n",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    coffee+' 누가 만들었나요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "다깡(지니)가 만든 어플로,\n믹스커피를 끊지 못하는 무를 위해 만들었습니다!\n",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.left,
                      )),

                  Text(
                    coffee+' 무슨 어플인가요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "믹스커피를 마실 때\n왜 믹스커피를 마셨는지,\n그때의 무의 기분을 기록하면 됩니다.\n",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.left,
                      )),
                  Text(
                    coffee+' 그러면 뭐가 좋나요?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "몇 잔 마셨는지, 무슨 기분으로 마셨는지\n기억할 수 있고,\n\n그러면 점차 끊을 수 있겠죠? "+dog+"\n\n\n",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown),
                        textAlign: TextAlign.left,
                      )),
                  Text(
                    yheart+' 오류가 발생하거나 원하는 기능이 있다면\n언제든지 카톡으로 문의 주세요. '+me,
                    style: TextStyle(
                      fontSize: 18,

                    ),
                    textAlign: TextAlign.left,
                  ),
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
