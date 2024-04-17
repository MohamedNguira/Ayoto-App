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

import 'dart:developer';

import 'package:ayoto/ProfileService.dart';
import 'package:ayoto/main.dart';



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



class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.token});

  final String token;

  @override
  State<CalendarScreen> createState() => CalendarScreenState();
}


Future<String> fetchUpcomingAppointments(userId) async {
  String body = '{"userId": "' + userId + '"}';
  log("fetchUpcomingAppointments in CalendarScreen body: " + body);

  //final response = await http.post(Uri.parse('https://api.ayoto.health/dataserver/appointments?includePast=true&includeFuture=true'),
  //final response = await http.post(Uri.parse('https://jsonkeeper.com/b/Q55J'),
  final response = await http.post(Uri.parse('https://sfasdfasdfs.free.beeceptor.com/dsafdsfad'),
      //body: '{"infermedicaId": "sp_12", "startDate": "2023-07-12", "endDate": "2023-07-15"}',
      body: body,
      headers: {
        "Content-Type": "application/json"
      }
  );

  log("fetchUpcomingAppointments in CalendarScreen response: " + response.body);
  log("fetchUpcomingAppointments in CalendarScreen code: " + response.statusCode.toString());

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print(response.body);
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}



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




class CustomTabBarWithWeeksSwitch extends StatefulWidget {
  const CustomTabBarWithWeeksSwitch({super.key, required this.json, required this.weeks, required this.initialWeekIndex});

  final List<dynamic> json;
  final weeks;
  final initialWeekIndex;


  @override
  State<CustomTabBarWithWeeksSwitch> createState() => CustomTabBarWithWeeksSwitchState();
}

class CustomTabBarWithWeeksSwitchState extends State<CustomTabBarWithWeeksSwitch> {
  //var weeks = [];
  late int currentWeekIndex;

  @override
  void initState() {
    currentWeekIndex = widget.initialWeekIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> json = jsonDecode("[]");

    for (int i = 0; i < widget.json.length; i++) {
      var currentDate = DateTime.parse(widget.json[i]["date"]);
      DateTime start = widget.weeks[currentWeekIndex]['start'];
      DateTime end = widget.weeks[currentWeekIndex]['end'];

      if (currentDate.isAfter(start) && currentDate.isBefore(end) || currentDate.isAtSameMomentAs(start) || currentDate.isAtSameMomentAs(end)) {
        json.add(widget.json[i]);
      }
    }

    //Copy paste from 3rd screen
    int maxNumOfDoctorsOnSingleDay = 0;
    for (int i = 0; i < json.length; i++) {
      int count = 0;
      for (int j = 0; j < json[i]["data"].length; j++) {
        dynamic appointmentData = json[i]["data"][j];
        if (
          appointmentData["doctorName"] == null || !appointmentData["doctorName"].trim().isNotEmpty ||
          appointmentData["start"] == null || !appointmentData["start"].trim().isNotEmpty// ||
          //appointmentData["doctorUUID"] == null || !appointmentData["doctorUUID"].trim().isNotEmpty
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



    String weekSwitchString = "";
    weekSwitchString += widget.weeks[currentWeekIndex]['start'].day.toString();
    weekSwitchString += "-";
    weekSwitchString += widget.weeks[currentWeekIndex]['end'].day.toString();
    weekSwitchString += " " + DateFormat('MMM').format(widget.weeks[currentWeekIndex]['end']) + " ";
    weekSwitchString += widget.weeks[currentWeekIndex]['end'].year.toString();



    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Container(
            // frame94y1y (724:24110)
            //margin:  EdgeInsets.fromLTRB(83*fem, 0*fem, 85*fem, 41.13*fem),
            padding:  EdgeInsets.fromLTRB(20, 19.43, 20, 19.43),
            width:  250, //double.infinity,
            decoration:  BoxDecoration (
              color:  Color(0xffd4ddfc),
              borderRadius:  BorderRadius.circular(29.6923065186),
            ),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment:  CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children:  [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (currentWeekIndex > 0) {
                        setState(() {
                          currentWeekIndex -= 1;
                        });
                      }
                    },
                    child: Image.asset(
                      "assets/images/_.png",
                      width: 8,
                      height: 17,
                    ),
                  ),
                ),
                //SizedBox(width: 12),
                Spacer(),
                Text(
                  // june2028nk7 (724:24112)
                  //'10-16 June 2028',
                  weekSwitchString,
                  textAlign:  TextAlign.center,
                  style: TextStyle(
                    fontFamily:  'Outfit',
                    fontSize:  20,
                    fontWeight:  FontWeight.w600,
                    //height:  1.1,
                    color:  Color(0xff0b1533),
                  ),
                ),
                //SizedBox(width: 12),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (currentWeekIndex < widget.weeks.length - 1) {
                      setState(() {
                        currentWeekIndex += 1;
                      });
                    }
                  },
                  child: Image.asset(
                    "assets/images/_ (1).png",
                    width: 8,
                    height: 17,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 41.13),

        Container(
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
                                  //json[index]["date"].split("-")[0], //'10',
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
                              //Copy paste from 3rd screen

                              dynamic appointmentData = json[index]["data"][appointmentIndex];
                              //print("Some non existing field");
                              //print(appointmentData["aboba"]);
                              //if (appointmentData["doctorName"])

                              if (
                                appointmentData["doctorName"] == null || !appointmentData["doctorName"].trim().isNotEmpty ||
                                appointmentData["start"] == null || !appointmentData["start"].trim().isNotEmpty// ||
                                //appointmentData["doctorUUID"] == null || !appointmentData["doctorUUID"].trim().isNotEmpty
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
                                    //if (splitName.join(" ").length > 24) {
                                    if (splitName.join(" ").length > 22) {
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


                              DateTime time = DateFormat('HH:mm').parse(appointmentData["start"]);
                              //String time12Hour = DateFormat('h:mm a').format(time);
                              appointmentData["startTimeFormatted"] = DateFormat('h:mm a').format(time);



                              return Container( //DOCTOR TILE
                                width: double.infinity,
                                height: 60,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                padding: EdgeInsets.fromLTRB(17, 10, 17, 10),
                                //Right is not confirmed
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      20),
                                  color: Color(0xffffffff),
                                ),
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
                                          json[index]["data"][appointmentIndex]["doctorName"],
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
                                          shortAddress,
                                          //json[index]["data"][appointmentIndex]["doctorAddress"],
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
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      //margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                      width: 5,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Color(0xffff3a2d),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ],
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
        )
      ],
    );
  }
}



class CalendarScreenState extends State<CalendarScreen> {
  late Future<String> futureUpcomingAppointments;

  //int activeDoctorPageIndex = -1;
  //int activeDoctorTileIndex = -1;

  //var weeks = [];
  //int currentWeekIndex = -1;

  List<dynamic> json = jsonDecode("[]");

  @override
    void initState() {
      super.initState();

      ProfileService().getProfile((ProfileDetails details){
        setState(() {
          //name = details.name!;
          //age = int.parse((details.age!).substring(0,2));
          MyHomePageState.userid = details.id!;
          //phone = details.phone!;
        });
      });

      futureUpcomingAppointments = fetchUpcomingAppointments(MyHomePageState.userid);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0xf5, 0xf7, 0xff, 1),
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



      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 25),
          Container(
            padding: EdgeInsets.fromLTRB(34, 25, 0, 0),
            child: Text(
              'Schedule of appointments',
              style: TextStyle(
                color: Color(0xFF152D37),
                fontSize: 18,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ),

          SizedBox(height: 38),

          FutureBuilder<String>( //THE WHOLE TAB BAR WILL BE LOADED WHEN JSON IS LOADED
            future: futureUpcomingAppointments,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //return Text(snapshot.data!.title);
                List<dynamic> json = jsonDecode(snapshot.data!);

                if (json.length == 0) {
                  return Container( //Okay should be good with the textbutton default height
                    padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
                    child: Text(
                      "You do not have upcoming appointments.",
                      style: TextStyle(
                        color: Color(0xFF152D37),
                        fontSize: 16,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }



                //Just in case json is not sorted by date
                var startDate = DateTime.parse(json[0]["date"]);
                //var endDate = DateTime.now(); //startDate;

                DateTime now = DateTime.now();
                int year = now.year;
                int month = now.month;
                int day = now.day;

                DateTime endDate = DateTime(year, month, day);

                //Will be needed later
                DateTime currentDate = endDate;


                for (int i = 1; i < json.length; i++) {
                  var thisDate = DateTime.parse(json[i]["date"]);
                  if (thisDate.isBefore(startDate)) {
                    startDate = thisDate;
                  } else if (thisDate.isAfter(endDate)) {
                    endDate = thisDate;
                  }
                }


                var weeks = [];

                // Calculate the start of the first week (always starting on Monday)
                var currentWeekStart = startDate.subtract(Duration(days: startDate.weekday - 1));

                // Iterate through weeks until we reach or exceed the end date
                while (currentWeekStart.isBefore(endDate) || currentWeekStart.isAtSameMomentAs(endDate)) {
                  final currentWeekEnd = currentWeekStart.add(Duration(days: 6));
                  weeks.add({'start': currentWeekStart, 'end': currentWeekEnd});
                  currentWeekStart = currentWeekStart.add(Duration(days: 7));
                }

                print(weeks);


                //DateTime currentDate = DateTime.now();
                int initialWeekIndex = -1;

                for (int i = 0; i < weeks.length; i++) {
                  DateTime start = weeks[i]['start'];
                  DateTime end = weeks[i]['end'];
                  if (currentDate.isAfter(start) && currentDate.isBefore(end) || currentDate.isAtSameMomentAs(start) || currentDate.isAtSameMomentAs(end)) {
                    initialWeekIndex = i;
                    break;
                  }
                }

                print("initialWeekIndex:");
                print(initialWeekIndex);



                return CustomTabBarWithWeeksSwitch(json: json, weeks: weeks, initialWeekIndex: initialWeekIndex);



              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              //return const CircularProgressIndicator();
              return Center(
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


