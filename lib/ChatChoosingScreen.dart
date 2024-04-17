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



class ChatChoosingScreen extends StatefulWidget {
  const ChatChoosingScreen({super.key, required this.token});

  final String token;

  @override
  State<ChatChoosingScreen> createState() => ChatChoosingScreenState();
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




class ChatChoosingScreenState extends State<ChatChoosingScreen> {
  late Future<String> futureUpcomingAppointments;

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
            padding: EdgeInsets.fromLTRB(27, 20, 25, 0),
            child: Row(
              children: [
                Text(
                  'Chats',
                  style: TextStyle(
                    color: Color(0xFF152D37),
                    fontSize: 18,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),

                SizedBox(width: 14),

                Expanded(
                  child: Container(
                    padding:  EdgeInsets.fromLTRB(7, 0, 0, 0),
                    height:  28,
                    decoration:  BoxDecoration (
                      color:  Colors.white,
                      borderRadius:  BorderRadius.circular(29.6923065186),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment:  CrossAxisAlignment.center,
                      children:  [
                        Container(
                          // image116tdd (725:24386)
                          margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 7*fem, 0*fem),
                          width:  11,
                          height:  11,
                          child: Image.asset(
                            "assets/images/image 116.png"
                            //fit:  BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            //alignment: Alignment.center,
                            margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 7*fem, 0*fem),
                            child: TextField(
                              maxLines: 1,
                              decoration: InputDecoration(
                                isDense: true, //Otherwise glitch
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0), //Otherwise glitch
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle:  TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize:  10,
                                  fontWeight:  FontWeight.w300,
                                  //height:  0.5,
                                  color:  Color(0xff5b6875),
                                ),
                              ),
                            ),
                          )
                        ),
                        //Spacer(),
                      ],
                    ),
                  ),
                )
              ],
            )
          ),



          SizedBox(height: 38),


          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                Container(
                  //width: 352.76,
                  height: 56.74,
                  decoration:  BoxDecoration (
                    //border:  Border.all(Color(0xffffffff)),
                    color:  Color(0xffffffff),
                    borderRadius:  BorderRadius.circular(29.6923065186*fem),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20), //This is approximate
                      Image.asset(
                        "assets/images/Group 9.png",
                        //fit:  BoxFit.cover,
                        width: 30, //This is approximate
                        height: 30, //This is approximate
                      ),
                      SizedBox(width: 20), //This is approximate
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //SizedBox(height: 11.35),
                          Text(
                            'AyotoChat',
                            style:  TextStyle(
                              fontFamily: 'Outfit',
                              fontSize:  15,
                              fontWeight:  FontWeight.w600,
                              height:  1.1,
                              color:  Color(0xff0b1533),
                            ),
                          ),
                          SizedBox(height: 2.09),
                          Text(
                            // yesihaveattachedthecertificate (725:24283)
                            'Yes, I have attached the cert...',
                            style:  TextStyle(
                              fontFamily: 'Outfit',
                              fontSize:  13,
                              fontWeight:  FontWeight.w400,
                              height:  1.1,
                              color:  Color(0xff0b1533),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'dot',
                            style:  TextStyle(
                              fontFamily: 'Outfit',
                              fontSize:  15,
                              fontWeight:  FontWeight.w600,
                              height:  1.1,
                              color:  Color(0xff0b1533),
                            ),
                          ),
                          SizedBox(height: 2.09),
                          Text(
                            '5:98 PM',
                            textAlign:  TextAlign.right,
                            style:  TextStyle(
                              fontFamily: 'Outfit',
                              fontSize:  12,
                              fontWeight:  FontWeight.w400,
                              height:  1.1,
                              color:  Color(0xff646e8a),
                            ),
                          ),
                        ]
                      ),
                      SizedBox(width: 12.76),
                    ],
                  )
                )
              ],
            )
          )

        ],
      ),
    );
  }
}


