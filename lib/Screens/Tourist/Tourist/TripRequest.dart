import 'dart:convert';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:tt/Chatroom/Chatroom.dart';
import 'package:tt/Widgets/LabelTextField.dart';
import 'package:http/http.dart' as http;
import 'package:tt/utils/ResponseData.dart';

String uId = ResponseData.userId;
String guideId = ResponseData.searchedGuide.toString();

class TripRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TripRequestState();
  }
}

class TripRequestState extends State<TripRequest> {
  String apiurl =
      'http://10.0.2.2:8000/api/makeTour?guide_id=$guideId&tourist_id=$uId';
  TextEditingController _type = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _place = TextEditingController();
  TextEditingController _noOfDays = TextEditingController();

  DateTime _jorneyDate;

  Map<String, dynamic> formData;
  List<String> types = [
    'Hike',
    'Beach',
    'Adventure',
    'Historical',
  ];

   

  TripRequestState() {
    formData = {
      // 'Type': 'Hike',
    };
  }

  void _makeTripRequest(BuildContext context) async {
    final Map<String, dynamic> data = {
      'tour_type': _type.text,
      'place': _place.text,
      'date': _jorneyDate.toString(),
      'No_of_days': _noOfDays.text,
      'status': "Pending",
    };
    var response = await http.post(apiurl,
        body: data, encoding: Encoding.getByName("application/json"));

    if (response.statusCode == 200) {
      setState(() {
        _type.text = "";
        _place.text = "";
        _date.text = "";
        _noOfDays.text = "";

        print(response.statusCode);

        Navigator.pop(context);
      });
    } else {
      print(response.body);
      Toast.show("Something went wrong! Try again ", context,
          duration: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Chat room",
        ),
        icon: Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Chatroom()));
        },
        backgroundColor: Colors.teal,
      ),
      appBar: AppBar(
        title: Text("Requesting the trip"),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Requested trips",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.2)),
        child: Form(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    DropDownField(
                        value: formData['Type'],
                        required: true,
                        hintText: 'Choose a type',
                        labelText: 'Type *',
                        items: types,
                        strict: true,
                        controller: _type,
                        setter: (dynamic newValue) {
                          formData['Type'] = newValue;
                        }),
                    SizedBox(
                      height: 16,
                    ),
                    LabelTextField(
                      hintText: 'Trip place',
                      labelText: 'Enter place you want to travel',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field can be empty';
                        }
                        return null;
                      },
                      textEditingController: _place,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _jorneyDate == null
                        ? ListTile(
                            trailing: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then((date) {
                                  setState(() {
                                    _jorneyDate = date;
                                  });
                                });
                              },
                            ),
                            title: LabelTextField(
                              hintText: 'Date',
                              labelText: "Journey Date",
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cant be empty';
                                }
                                return null;
                              },
                              textEditingController: _date,
                            ),
                          )
                        : LabelTextField(
                            hintText: 'Date',
                            labelText: _jorneyDate.toString(),
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field cant be empty';
                              }
                              return null;
                            },
                            textEditingController: _date,
                          ),
                    SizedBox(
                      height: 16,
                    ),
                    LabelTextField(
                      hintText: 'No of days',
                      labelText: 'No of days',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field cant be empty';
                        }
                        return null;
                      },
                      textEditingController: _noOfDays,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          if(_type.text.isEmpty ==true|| _place.text.isEmpty==true||_date.text.isEmpty==true||_noOfDays.text.isEmpty==true){
                          _makeTripRequest(context);
                          }
                        },
                        child: Text(
                          "Sumbit request",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.teal,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
