//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:buttons_tabbar/buttons_tabbar.dart';

import 'MyHeader.dart';
import 'CurrentPriorityText.dart';

import 'AppointmentScreen.dart';

import 'package:intl/intl.dart';

import 'ServerCreateChat.dart';



String capitalizeWords(String input) {
  // Split the input string into individual words
  List<String> words = input.split(' ');

  // Capitalize the first letter of each word
  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    if (word.isNotEmpty) {
      words[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
  }

  // Join the words back together
  String capitalizedString = words.join(' ');

  return capitalizedString;
}



class ChoosingScreen extends StatefulWidget {
  const ChoosingScreen({super.key});
  @override
  State<ChoosingScreen> createState() => ChoosingScreenState();
}


Future<String> fetchUpcomingAppointments(String specialization) async {
  //final response = await http
  //    .get(Uri.parse('https://sflasjdflakjsfldkajdsf.free.beeceptor.com/aboba')); //https://jsonkeeper.com/b/1KLR
  //Maybe without www doesn't work because of headers or something. Or what else can differ from my browser

  /*
  final request = http.Request("get", Uri.parse("https://api.ayoto.health/dataserver/possibleAppointments"));
  var jsonPayload = '{"infermedicaId": "sp_12", "startDate": "2023-07-11T07:18:18.162Z", "endDate": "2023-07-11T07:18:18.162Z", "latitude": 0, "longitude": 0}';
  request.body = jsonPayload;

  var sent = await http.Client().send(request);
  var response = await http.Response.fromStream(sent);
  */



  //GOOD REQUEST TO THE ACTUAL SERVER
  final response = await http.post(Uri.parse('https://api.ayoto.health/dataserver/possibleAppointments'),
      //body: '{"infermedicaId": "sp_12", "startDate": "2023-07-12", "endDate": "2023-07-15"}',
      body: '{"infermedicaId": "' + specialization + '", "startDate": "2023-07-12", "endDate": "2023-07-15"}',
      headers: {
        "Content-Type": "application/json"
      }
  );




  //FOR ERROR TESTING
  //final response = await http
  //      .get(Uri.parse('https://www.jsonkeeper.com/b/6KJY'));

  //final response = await http
  //        .get(Uri.parse('https://www.jsonkeeper.com/b/OEO1'));

  print(response);
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


/*
class PossibleAppointmentData { //Better than use json
  const PossibleAppointmentData({
      required this.priority,
      required this.doctorName,
      required this.doctorSpecialization,
      required this.doctorCity,
      required this.weekday,
      required this.date,
      required this.start,
      required this.daysRemaining,
      required this.distanceAway,
      required this.appointmentSlotID
    });

    final String priority;
    final String doctorName;
    final String doctorSpecialization;
    final String doctorCity;
    final String weekday;
    final String date;
    final String start;
    final String daysRemaining;
    final String distanceAway;
    //final String phoneNumber;
    final String appointmentSlotID;
}
*/

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}



class ChoosingScreenState extends State<ChoosingScreen> {
  static late Query query;



  late Future<String> futureUpcomingAppointments;

  List<dynamic> json = jsonDecode("[]");

  int activeDoctorPageIndex = -1;
  int activeDoctorTileIndex = -1;

  @override
    void initState() {
      super.initState();

      print("ChoosingScreenState");
      print(query);
      print(jsonEncode(query.toJson()));

      futureUpcomingAppointments = fetchUpcomingAppointments(query.specialization!);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0xf5, 0xf7, 0xff, 1),



      bottomNavigationBar: Container( //NO WAY WE PUT THIS IN SEPARATE CLASS OR WE CAN BE WE WILL NEED TO PASS PRIMITIVE CLASS BY REFERENCE...
        height: 48, //...USING WRAPPER
        margin: EdgeInsets.fromLTRB(27, 0, 27, 10),
        child: ElevatedButton(
          onPressed: () {
            //dynamic thisPage = json[activeDoctorPageIndex];
            //dynamic thisAppointment = thisPage["data"][activeDoctorTileIndex]
            //PossibleAppointmentData("High", thisPage["doctorName"])

            /*Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute<bool>(
                fullscreenDialog: true,
                builder: (BuildContext context) =>
                  AppointmentScreen(
                    date: json[activeDoctorPageIndex]["date"],
                    weekday: json[activeDoctorPageIndex]["weekday"],
                    json: json[activeDoctorPageIndex]["data"][activeDoctorTileIndex]
                  )
              )
            );*/
            Navigator.of(context).push(createRoute(AppointmentScreen(
              date: json[activeDoctorPageIndex]["date"],
              weekday: json[activeDoctorPageIndex]["weekDay"],
              json: json[activeDoctorPageIndex]["data"][activeDoctorTileIndex]
            )));
          },
          child: Text(
            'Proceed with booking',
            style:  TextStyle (
              fontFamily: 'Outfit',
              fontSize:  16,
              fontWeight:  FontWeight.w500,
              height:  1.1,
              color:  Color(0xffffffff),
            ),
          ),
          style: ButtonStyle(
            //maximumSize: MaterialStateProperty.all(Size(130, 31)),
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff577df5)),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
              ),
            ),
          ),
        )
      ),



      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FF),
        title: Column(
          children: [
            //SizedBox(height: 54),
            MyHeader(),
          ],
        ),
        elevation: 0,
      ),



      body: ListView( //Column(
        scrollDirection: Axis.vertical,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(27, 17, 27, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 17),
                Text(
                  'Our chatbot evaluates your current situation and books and appointment depending on how critical it is.',
                  style: TextStyle(
                    color: Color(0xFF152D37),
                    fontSize: 16,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 20), //This should be 31
                CurrentPriorityText(),
                SizedBox(height: 20), //This should be 30

                Text(
                  'Possible appointments',
                  style: TextStyle(
                    color: Color(0xFF152D37),
                    fontSize: 16,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    height:  1.1,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 14),

          FutureBuilder<String>( //THE WHOLE TAB BAR WILL BE LOADED WHEN JSON IS LOADED
            future: futureUpcomingAppointments,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //return Text(snapshot.data!.title);
                json = jsonDecode(snapshot.data!);

                int maxNumOfDoctorsOnSingleDay = 0;
                for (int i = 0; i < json.length; i++) {
                  int count = 0;
                  for (int j = 0; j < json[i]["data"].length; j++) {
                    dynamic appointmentData = json[i]["data"][j];
                    if (
                      appointmentData["doctorName"] == null || !appointmentData["doctorName"].trim().isNotEmpty ||
                      appointmentData["startTime"] == null || !appointmentData["startTime"].trim().isNotEmpty ||
                      appointmentData["doctorUUID"] == null || !appointmentData["doctorUUID"].trim().isNotEmpty
                    ) {
                      continue;
                    }
                    count++;
                  }
                  if (count > maxNumOfDoctorsOnSingleDay) {
                    maxNumOfDoctorsOnSingleDay = count;
                  }
                }

                print(maxNumOfDoctorsOnSingleDay);

                return Container(
                  //constraints: BoxConstraints(maxHeight: 1000, maxWidth: 1000),
                  //width: 300,
                  //height: 300, //Controls the available space for the whole thing with tabs and labels
                  child: DefaultTabController(
                    //animationDuration: Duration.zero,
                        length: json.length, //2,
                        child: Column(
                          children: [
                            Container(
                              height: 85, //15 pixels of margin
                              child: ButtonsTabBar(
                                unselectedLabelStyle: TextStyle(color: Color(0xff0b1533)),
                                labelStyle: TextStyle(color: Color(0xff0b1533)),
                                backgroundColor: Color(0xffd4ddfc),
                                unselectedBackgroundColor: Color(0xffffffff),
                                radius: 20,
                                buttonMargin: EdgeInsets.fromLTRB(5, 0, 5, 15), //EdgeInsets.all(5), //This is margin as well from bottom and therefore probably top
                                contentPadding: EdgeInsets.all(0),

                                /*
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black,
                                isScrollable: true, //Makes tabs fit
                                //labelPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                indicatorPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  color: Color(0xffcdf1fe), //Colors.pink,
                                ),
                                */
                                //indicatorColor: Colors.transparent,
                                tabs: List.generate( //GENERATING TABS
                                  json.length,
                                  (index) {
                                    //print("Some non existing field");
                                    //print(json[index]["aboba"] == null);
                                    //print("".isNotEmpty);
                                    //print(" ".trim().isNotEmpty);


                                    /*TO DO:
                                    if (json[index]["date"] == null || !json[index]["date"].trim().isNotEmpty) {
                                      //Probably if there is already not empty string
                                      //Then there is a high probability that this string contains the date
                                      return Tab(child: Container(width: 0, height: 0));
                                      //return null;
                                    }

                                     */



                                    return Tab(
                                      child: Container(
                                        width: 60,
                                        height: 70,
                                        //margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        /*decoration:  BoxDecoration (
                                                      borderRadius:  BorderRadius.circular(20),
                                                      color:  Colors.black,
                                                    ),*/
                                        child: Column(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              json[index]["date"].split("-")[2],
                                              //'10',
                                              style:  TextStyle(
                                                fontFamily: 'Outfit',
                                                fontSize:  22,
                                                fontWeight:  FontWeight.w600,
                                                height:  1.1,
                                                color:  Color(0xff0b1533),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              json[index]["weekDay"][0] + json[index]["weekDay"].toString().substring(1, 3).toLowerCase(),
                                              //'Mon',
                                              style:  TextStyle(
                                                fontFamily: 'Outfit',
                                                fontSize:  12,
                                                height:  1.1,
                                                color:  Color(0xff0b1533),
                                              ),
                                            ),
                                          ]
                                        ),
                                      )
                                    );
                                  }
                                ),
                              ),
                            ),
                            Container(
                              height: 70.0 * maxNumOfDoctorsOnSingleDay,
                              child: TabBarView(
                                children: List.generate( //GENERATING TABS
                                  json.length,
                                  (index) {
                                    return Column(
                                      children: List.generate(
                                        json[index]["data"].length,
                                        (appointmentIndex) {
                                          dynamic appointmentData = json[index]["data"][appointmentIndex];
                                          //print("Some non existing field");
                                          //print(appointmentData["aboba"]);
                                          //if (appointmentData["doctorName"])

                                          if (
                                            appointmentData["doctorName"] == null || !appointmentData["doctorName"].trim().isNotEmpty ||
                                            appointmentData["startTime"] == null || !appointmentData["startTime"].trim().isNotEmpty ||
                                            appointmentData["doctorUUID"] == null || !appointmentData["doctorUUID"].trim().isNotEmpty
                                          ) {
                                            //Probably if there is already not empty string
                                            //Then there is a high probability that this string contains the date
                                            return Container();
                                          }


                                          appointmentData["doctorName"] = capitalizeWords(appointmentData["doctorName"]);

                                          appointmentData["doctorName"] = appointmentData["doctorName"]
                                              .replaceAll("Prof.", "")
                                              //.replaceAll("prof.", "")
                                              .replaceAll("Professor", "")
                                              //.replaceAll("prof", "")
                                              .replaceAll("Col.(Retd.)", "")
                                              //.replaceAll("col.(Retd.)", "")
                                              .replaceAll("Col.(retd.)", "")
                                              //.replaceAll("col.(retd.)", "")
                                              .replaceAll("Assoc.", "")
                                              .replaceAll("Prof", "").trim();

                                          List<String> splitName = appointmentData["doctorName"].split(" ");

                                          //If send word is abbreviation then if we need to abbreviate more, we check if it has dot
                                          //Prof. Dr. S M. Siddiqur Rahman

                                          try {
                                            for (int i = 1; i < splitName.length; i++) {
                                              if (splitName[i][0] == '(' && splitName[i][splitName[i].length - 1] == ')') {
                                                splitName.removeAt(i);
                                                i--;
                                              }
                                            }
                                          } catch (e) {
                                            print(e);
                                            print(appointmentData["doctorName"]);
                                            print(appointmentData);
                                          }

                                          for (int i = 1; i < splitName.length; i++) {
                                            if (!splitName[i].contains(".") && splitName[i].length > 2) {
                                              //Then this is a full name word
                                              if (i < splitName.length - 2) {
                                                //Shortening it, if it is not among the last two name words
                                                splitName[i] = splitName[i][0] + ".";
                                              } else if (i == splitName.length - 2) {
                                                //Or if it is among the last two but the result is too long anyway
                                                if (splitName.join(" ").length > 22) {
                                                //if (splitName.join(" ").length > 24) {
                                                  splitName[i] = splitName[i][0] + ".";
                                                }
                                              }
                                            }
                                          }

                                          appointmentData["doctorName"] = splitName.join(" ");


                                          String shortAddress = "";
                                          if (appointmentData["doctorAddress"] != null && appointmentData["doctorAddress"].trim().isNotEmpty) {
                                            List<String> splitAddress = appointmentData["doctorAddress"].split(", ");
                                            shortAddress = splitAddress[1] + ", " + splitAddress[splitAddress.length - 2];
                                          }


                                          DateTime time = DateFormat('HH:mm').parse(appointmentData["startTime"]);
                                          //String time12Hour = DateFormat('h:mm a').format(time);
                                          appointmentData["startTimeFormatted"] = DateFormat('h:mm a').format(time);


                                          return Container( //DOCTOR TILE
                                            width: double.infinity,
                                            height: 60,
                                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                            //padding: EdgeInsets.fromLTRB(17, 10, 17, 10),
                                            //Right is not confirmed

                                            child: Material(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    activeDoctorPageIndex = index;
                                                    activeDoctorTileIndex = appointmentIndex;
                                                    print("Index of the pressed tile: ");
                                                    print(appointmentIndex);
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: AssetImage("assets/images/DED.png"),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          appointmentData["doctorName"],
                                                          //json[index]["data"][appointmentIndex]["doctorName"],
                                                          //json[index]["data"][appointmentIndex]["doctorName"].toString().split(" ").sublist(0, 2).join(" "),
                                                          //'Dr. Istvan Emre',
                                                          //json[index]["name"],
                                                          style: TextStyle(
                                                            fontFamily: 'Outfit',
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.1,
                                                            color: Color(0xff0b1533),
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          shortAddress + (appointmentData["distanceAway"] != null ? (" (" + appointmentData["distanceAway"] + " km)") : ""),
                                                          //json[index]["data"][appointmentIndex]["doctorStreetOrHospitalName"] + ", " + json[index]["data"][appointmentIndex]["doctorCity"] + " (" + json[index]["data"][appointmentIndex]["distanceAway"] + " km)",
                                                          style: TextStyle(
                                                            fontFamily: 'Outfit',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w400,
                                                            height: 1.1,
                                                            color: Color(0xff0b1533),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      appointmentData["startTimeFormatted"],
                                                      //json[index]["data"][appointmentIndex]["start"],
                                                      //'8:00 AM',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Outfit',
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.1,
                                                        color: Color(0xff0b1533),
                                                      ),
                                                    ),/*
                                                    SizedBox(width: 6),
                                                    Container(
                                                      //margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                                      width: 5,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xffff3a2d),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                    ),*/
                                                  ],
                                                ),
                                                style: ButtonStyle(
                                                  //maximumSize: MaterialStateProperty.all(Size(130, 31)),
                                                  overlayColor: MaterialStateColor.resolveWith((states) => Color(0xffabcbfb)),
                                                  backgroundColor: activeDoctorTileIndex == appointmentIndex && activeDoctorPageIndex == index ? MaterialStateProperty.all<Color>(Color(0xffd4ddfc)) : MaterialStateProperty.all<Color>(Color(0xffffffff)),
                                                  elevation: MaterialStateProperty.all(0),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          );
                                        }
                                      ),
                                    );
                                  }
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              //return const CircularProgressIndicator();
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: CircularProgressIndicator()
              );
            }
          ),

          /*
          Container(
            //height: 33.96,
            width: 198,
            child: OutlinedButton(
              onPressed: () {},
              child: Text(
                'Search for other dates',
                style:  TextStyle(
                  fontFamily: 'Outfit',
                  fontSize:  14,
                  fontWeight:  FontWeight.w500,
                  height:  1.1,
                  color:  Color(0xff03b2f0),
                ),
              ),
              style: ButtonStyle(
                //maximumSize: MaterialStateProperty.all(Size(130, 31)),
                //backgroundColor: MaterialStateProperty.all<Color>(Color(0xffd74343)),
                //elevation: MaterialStateProperty.all(0),
                side: MaterialStateProperty.all(BorderSide(color: Color(0xff03b2f0))),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                ),
              ),
            ),
          ),

           */
        ],
      ),
    );
  }
}


