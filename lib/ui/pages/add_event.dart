import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:moo_app/model/event.dart';
import 'package:flutter/material.dart';
import 'package:moo_app/res/event_firestore_service.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddEventPage extends StatefulWidget {
  final EventModel note;

  const AddEventPage({Key key, this.note}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
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

class _AddEventPageState extends State<AddEventPage> {
  TextStyle style = TextStyle(fontSize: 18.0);
  TextEditingController _description;
  DateTime _eventDate;
  String currentTimeZone;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;
  File _image;

  void _uploadImageToStorage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    if (image == null) return;
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
    _eventDate = DateTime.now();
    processing = false;
    _image = null;
  }

  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    var coffee = parser.emojify(':coffee:');
    var calendar = parser.emojify(':calendar:');
    var camera = parser.emojify(':camera:');
    return Scaffold(

      appBar: AppBar(
        title: Text(" Add note"),
        backgroundColor: HexColor("#abc0e1"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 17.0),
            children: <Widget>[
              Text(
                "   " + coffee + " 오늘 무는 믹스커피를 왜 마셨나요?",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 13),
              _image != null
                  ? new ClipRect(
                      child: ClipRRect(
                          borderRadius: new BorderRadius.circular(5.0),
                          child: Image(
                            image: FileImage(_image),
                            fit: BoxFit.fill,
                            height: 400,
                            width: 200,
                          )))
                  : new Container(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 5,
                  maxLines: 10,
                  validator: (value) =>
                      (value.isEmpty) ? "내용이 입력되지 않았습니다!" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(height: 5),
              MaterialButton(
                child: Text("사진도 넣을 수 있어요! " + camera,
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                padding: EdgeInsets.symmetric(horizontal: 80.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: HexColor("#b0c5c6"),
                onPressed: () {
                  _uploadImageToStorage(ImageSource.gallery);
                },
              ),
              SizedBox(height: 10),
              Text(
                "   $calendar 날짜 혹은 시간을 바꾸고 싶을 때 눌러주세요!",
                style: TextStyle(fontSize: 16),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                title: Text(
                    "${_eventDate.year} / ${_eventDate.month} / ${_eventDate.day}"),
                subtitle: Text("${_eventDate.hour} : ${_eventDate.minute}"),
                onTap: () async {
                  DateTime picked = await DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      currentTime: _eventDate, onConfirm: (date) {
                    _eventDate = date;
                  }, locale: LocaleType.ko);
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: HexColor("#abc0e1"),
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });

                              if (widget.note != null) {
                                await eventDBS.updateData(widget.note.id, {
                                  "description": _description.text,
                                  "event_date": widget.note.eventDate,
                                  "imgURL": _image != null ? _image.path : "",
                                });
                              } else {
                                await eventDBS.createItem(EventModel(
                                    description: _description.text,
                                    eventDate: _eventDate,
                                    imgURL: _image != null ? _image.path : ""));
                              }
                              Navigator.of(context).pop();
                              setState(() {
                                processing = false;
                              });
                            }
                            if(_image!=null){
                              StorageReference storageReference = _firebaseStorage.ref().child("events/$_image");
                              StorageUploadTask storageUploadTask = storageReference.putFile(_image);
                              await storageUploadTask.onComplete;
                            }
                          },
                          child: Text(
                            "기록하기",
                            style: style.copyWith(
                              color: Colors.white,
                              backgroundColor: HexColor("#abc0e1"),
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }
}
