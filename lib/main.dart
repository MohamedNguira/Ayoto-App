import 'dart:convert';

import 'package:ayoto/ChatChoosingScreen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:buttons_tabbar/buttons_tabbar.dart';

import 'ChatScreen.dart';
import 'PriorityWidget.dart';
import 'authentication/LoginScreen.dart';
import 'authentication/SignupScreen.dart';

import 'MyHeader.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intl/intl.dart';

import 'dart:developer';

import 'CalendarScreen.dart';
import 'ChoosingScreen.dart';
import 'ServerCreateChat.dart';


double fem = 0.92;
double ffem = 0.92;

//Copy paste from 3rd screen
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





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ayoto",
      home: MyHomePage(title: 'Ayoto Home Page'),
      theme: ThemeData(
        //primaryColor: const Color(0xFFF5F7FF),
        scaffoldBackgroundColor: const Color(0xFFF5F7FF),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}


Future<String> fetchUpcomingAppointments(userId) async {
  String body = '{"userId": "' + userId + '"}';
  log("fetchUpcomingAppointments in main body: " + body);

  final response = await http.post(Uri.parse('https://api.ayoto.health/dataserver/appointments?includePast=false&includeFuture=true'),
      //body: '{"infermedicaId": "sp_12", "startDate": "2023-07-12", "endDate": "2023-07-15"}',
      body: body,
      headers: {
        "Content-Type": "application/json"
      }
  );


  log("fetchUpcomingAppointments in main response: " + response.body);
  log("fetchUpcomingAppointments in main code: " + response.statusCode.toString());

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


class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Future<String> futureUpcomingAppointments;
  late final TabController _tabController;

  static int state = 2; //0: Signup, 1: Login, 2: mainview
  static String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyNTU4MGY0OC0xNmU3LTQ3ZDItYmQzMi0xNDdhNzZiYTg4M2UiLCJpYXQiOjE2OTQ2MDcyMTgsImV4cCI6MTY5NDYyMTYxOH0.ekeHztp1yDWp0m7XmfsSfGxWyQUe0sP6iGJ99urftYs",
      userid = "25580f48-16e7-47d2-bd32-147a76ba883e";
  void putloginscreen(){
    setState(() {
      state = 1;
    });
  }
  void putsignupscreen(){
    setState(() {
      state = 0;
    });
  }
  void putmainviewscreen(){
    setState(() {
      state = 2;

      //userid = "3fa85f64-5717-4562-b3fc-2c963f66afa6";
      //token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI3MjA1Y2FjNC1hZTlhLTQ4ZjEtYWUyOC05OGI1NDA4ZDNlNjgiLCJwYXRpZW50IjoiM2M3NjRkN2ItOTZmNy00M2EzLWIzZGYtOGE1MTMwYzY5NDUyIiwiaWF0IjoxNjg5MTgyMDkyLCJleHAiOjE2ODkxOTY0OTJ9.F1D3kSjRDUxgLphSUwdW1EAlqGgtcAlO7gKGxBnWz_E";

      futureUpcomingAppointments = fetchUpcomingAppointments(userid);
    });
  }

/*
  void reloadUpcomingAppointments() {
    setState(() {
      futureUpcomingAppointments = fetchUpcomingAppointments(userid);
    });
  }
 */


  @override
  void initState() {
    super.initState();
    futureUpcomingAppointments = fetchUpcomingAppointments(userid);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainview = Scaffold(
      body: ListView( //Column(
        //mainAxisAlignment: MainAxisAlignment.center,

        //crossAxisAlignment: CrossAxisAlignment.start,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          //SizedBox(height: 54), //2 times 27
          //MyHeader(),
          //Text("Hello", textAlign: TextAlign.left),
          //SizedBox(height: 7), //I calculated this, appBar is 56 pixels, so 8 we already have
          Container(
            padding: EdgeInsets.fromLTRB(27, 7, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello", style: TextStyle(fontFamily: "Outfit", fontSize: 16, height: 0.73, color: Color(0xff0b1533))),
                SizedBox(height: 7),
                Row( //This expands cuz default mainAxisSize is max
                  children: [
                    Text("Vladimir ", style: TextStyle(fontFamily: "Outfit", fontSize: 24, height: 0.73, color: Color(0xff0b1533))),
                    Text("Santos", style: TextStyle(fontFamily: "Outfit", fontSize: 24, height: 0.73, color: Color(0xff0b1533), fontWeight: FontWeight.w600))
                  ],
                ),
              ],
            )
          ),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            //height: 20,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: EdgeInsets.fromLTRB(17, 17, 0, 0),
            decoration:  BoxDecoration (
              borderRadius:  BorderRadius.circular(20),
              color:  Color(0xffcdf1fe),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -5, //0,
                  right: -15, //-10,
                  child: Image.asset("assets/images/8487361 1.png", height: 231, width: 231)
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you having\nsome symptoms?',
                      style:  TextStyle(
                        fontFamily: 'Outfit',
                        fontSize:  20,
                        fontWeight:  FontWeight.w600,
                        height:  1.1,
                        color:  Color(0xff0b1533),
                      ),
                    ),
                    SizedBox(height: 9),
                    Text(
                      'Our AI-Powered Chatbot\ncan help you with medical\ntips and advice',
                      style:  TextStyle(
                        fontFamily: 'Outfit',
                        fontSize:  14,
                        height:  1.2,
                        color:  Color(0xff0b1533),
                      ),
                    ),
                    SizedBox(height: 14),
                    Container(
                      height: 31,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen(token: token)));
                        },
                        child: Text(
                          'Chat with our Chatbot',
                          style:  TextStyle (
                            fontFamily: 'Outfit',
                            fontSize:  14*ffem,
                            fontWeight:  FontWeight.w500,
                            height:  1.1,
                            color:  Color(0xffffffff),
                          ),
                        ),
                        style: ButtonStyle(
                          //maximumSize: MaterialStateProperty.all(Size(130, 31)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff03b2f0)),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                  ]
                ),
              ]
            )
          ),

          SizedBox(height: 20),

          Container(
            width: double.infinity,
            //height: 20,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
            decoration:  BoxDecoration (
              borderRadius:  BorderRadius.circular(20),
              color:  Color(0xfff7d9d9),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -13, //The real one: -23, //0,
                  right: 0, //-10,
                  child: Image.asset("assets/images/8071299 1.png", height: 140, width: 140)
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 17),
                    Text(
                      'Having an\nemergency case?',
                      style:  TextStyle(
                        fontFamily: 'Outfit',
                        fontSize:  20,
                        fontWeight:  FontWeight.w600,
                        height:  1.1,
                        color:  Color(0xff0b1533),
                      ),
                    ),
                    SizedBox(height: 11),
                    Container(
                      height: 31,
                      child: ElevatedButton(
                        onPressed: () => launchUrl(Uri.parse('tel:911')),
                        child: Text(
                          'Call emergency',
                          style:  TextStyle (
                            fontFamily: 'Outfit',
                            fontSize:  14*ffem,
                            fontWeight:  FontWeight.w500,
                            height:  1.1,
                            color:  Color(0xffffffff),
                          ),
                        ),
                        style: ButtonStyle(
                          //maximumSize: MaterialStateProperty.all(Size(130, 31)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xffd74343)),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                  ]
                ),
              ]
            )
          ),

          Container( //Okay should be good with the textbutton default height
            padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
            child: Row(
              children:  [
                Text(
                  'Upcoming appointments',
                  style:  TextStyle (
                    fontFamily: 'Outfit',
                    fontSize:  16*ffem,
                    fontWeight:  FontWeight.w600,
                    height:  1.1,
                    color:  Color(0xff0b1533),
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View all',
                    style:  TextStyle(
                      fontFamily: 'Outfit',
                      fontSize:  12,
                      fontWeight:  FontWeight.w400,
                      height:  1.1,
                      color:  Color(0xff0082f7),
                    ),
                  ),
                )
              ],
            )
          ),



/* THIS IS STATIC TAB BAR LABEL
          Container(
            //width: double.infinity,
            width: 60,
            height: 70, //Better than to use paddings in this case when the size is fixed
            //height: 20,
            //alignment: Alignment.center, Using mainaxisalignment in the column instead
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            //padding: EdgeInsets.fromLTRB(15, 15, 15, 13), //Padding from left to right is approximate
            decoration:  BoxDecoration (
              borderRadius:  BorderRadius.circular(20),
              color:  Color(0xffcdf1fe),
            ),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '10',
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
                  'Mon',
                  style:  TextStyle(
                    fontFamily: 'Outfit',
                    fontSize:  12,
                    height:  1.1,
                    color:  Color(0xff0b1533),
                  ),
                ),
              ]
            )
          ),

*/

          /* THIS IS FUTURE BUILDER TEMPLATE
                FutureBuilder<String>(
                  future: futureUpcomingAppointments,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      //return Text(snapshot.data!.title);
                      List<dynamic> json = jsonDecode(snapshot.data!);
                      return Column( //ListView( //Column(
                        //scrollDirection: Axis.vertical,
                        children: List.generate(
                            5, //json.length,
                            (index) {
                              return Container(
                              */



          /*TRIED TO USE TABBARVIEW WITHOUT TABBAR BUT WITH BUTTONS (INKWELLS)

          FutureBuilder<String>( //THE WHOLE TAB BAR WILL BE LOADED WHEN JSON IS LOADED
            future: futureUpcomingAppointments,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //return Text(snapshot.data!.title);
                List<dynamic> json = jsonDecode(snapshot.data!);

                _tabController = TabController(length: json.length, vsync: this); //, animationDuration: Duration.zero);

                return Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Row(
                      children: List.generate( //GENERATING TABS
                        json.length,
                        (index) {
                          return Material(
                            child: InkWell(
                                                        child: Container(
                                                          //margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                          width: 60,
                                                          height: 70,
                                                          decoration: BoxDecoration (
                                                            borderRadius: BorderRadius.circular(20),
                                                            //color: Color(0xffd4ddfc),
                                                          ),
                                                          child: Column(
                                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                '10',
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
                                                                'Mon',
                                                                style:  TextStyle(
                                                                  fontFamily: 'Outfit',
                                                                  fontSize:  12,
                                                                  height:  1.1,
                                                                  color:  Color(0xff0b1533),
                                                                ),
                                                              ),
                                                            ]
                                                          ),
                                                        ),
                                                      )
                          );
                        }
                      ),
                    ),

                    Container(
                      height: 200,
                    child:
                    DefaultTabController(
                                        animationDuration: Duration.zero,
                                            length: 2,
                                            child: Scaffold(
                                              appBar: AppBar(
                                                elevation: 0,
                                                backgroundColor: const Color(0xFFF5F7FF),
                                                //title: const Text('Settings'),
                                                bottom: PreferredSize(
                                                  preferredSize: Size.fromHeight(14), //Size.fromHeight(AppBar().preferredSize.height),
                                                  child: Container(
                                                    height: 0,
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5,
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(
                                                          20,
                                                        ),
                                                        color: const Color(0xFFF5F7FF), //Color(0xffcdf1fe), //Colors.grey[200],
                                                      ),
                                                      child: TabBar(
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
                                                        //indicatorColor: Colors.transparent,
                                                        tabs: List.generate( //GENERATING TABS
                                                          json.length,
                                                          (index) {
                                                            return Tab(
                                                              child: Container(
                                                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                                /*decoration:  BoxDecoration (
                                                                              borderRadius:  BorderRadius.circular(20),
                                                                              color:  Colors.black,
                                                                            ),*/
                                                                child: Column(
                                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      json[index]["date"].split("-")[0], //'10',
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
                                                                      'Mon',
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
                                                  ),
                                                ),
                                              ),
                                              body: TabBarView(
                                                children: List.generate( //GENERATING TABS
                                                  json.length,
                                                  (index) {
                                                    return Column(
                                                      children: List.generate(
                                                        json[index]["data"].length,
                                                        (appointmentIndex) {
                                                          return Container( //DOCTOR TILE
                                                            width: double.infinity,
                                                            height: 60,
                                                            margin: EdgeInsets.fromLTRB(
                                                                10, 0, 10, 10),
                                                            padding: EdgeInsets.fromLTRB(
                                                                17, 10, 17, 10),
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
                                                                  backgroundImage: AssetImage(
                                                                      "assets/images/DED.png"),
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
                                                                      json[index]["data"][appointmentIndex]["doctorAddress"],
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
                                                                  json[index]["data"][appointmentIndex]["start"],
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
                                                                  width: 5 * fem,
                                                                  height: 15 * fem,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(0xffff3a2d),
                                                                    borderRadius: BorderRadius
                                                                        .circular(20 * fem),
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
                                            ),
                                          )
                                                )

                  ],
                );
*/
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
                              child:
                            TabBarView(
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
                );
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






/* THIS IS STATIC GOOD TAB BAR
          Container(
            //width: 300,
            height: 120,
            child: DefaultTabController(
              animationDuration: Duration.zero,
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: const Color(0xFFF5F7FF),
                      //title: const Text('Settings'),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(14), //Size.fromHeight(AppBar().preferredSize.height),
                        child: Container(
                          height: 70,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                              color: const Color(0xFFF5F7FF), //Color(0xffcdf1fe), //Colors.grey[200],
                            ),
                            child: TabBar(
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
                              //indicatorColor: Colors.transparent,
                              tabs: [
                                Tab(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    /*decoration:  BoxDecoration (
                                                  borderRadius:  BorderRadius.circular(20),
                                                  color:  Colors.black,
                                                ),*/
                                    child: Column(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '10',
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
                                          'Mon',
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
                                ),
                                Tab(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Column(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '10',
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
                                          'Mon',
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
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    body: const TabBarView(
                      children: [
                        Center(
                          child: Text(
                            'Basic Settings',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Advanced Settings',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
          )*/





        /* THIS IS STATIC DOCTOR TILE
        Container(
                                            width: double.infinity,
                                            height: 60,
                                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            padding: EdgeInsets.fromLTRB(17, 10, 17, 10), //Right is not confirmed
                                            decoration:  BoxDecoration (
                                              borderRadius:  BorderRadius.circular(20),
                                              color:  Color(0xffffffff),
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Dr. Istvan Emre',
                                                      //json[index]["name"],
                                                      style:  TextStyle (
                                                        fontFamily: 'Outfit',
                                                        fontSize:  16,
                                                        fontWeight:  FontWeight.w600,
                                                        height:  1.1,
                                                        color:  Color(0xff0b1533),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      'Pannon Hospital, Debrecen',
                                                      style:  TextStyle (
                                                        fontFamily: 'Outfit',
                                                        fontSize:  12,
                                                        fontWeight:  FontWeight.w400,
                                                        height:  1.1,
                                                        color:  Color(0xff0b1533),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  '8:00 AM',
                                                  textAlign:  TextAlign.center,
                                                  style:  TextStyle (
                                                    fontFamily: 'Outfit',
                                                    fontSize:  14,
                                                    fontWeight:  FontWeight.w600,
                                                    height:  1.1,
                                                    color:  Color(0xff0b1533),
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Container(
                                                  //margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                                  width:  5*fem,
                                                  height:  15*fem,
                                                  decoration:  BoxDecoration (
                                                    color:  Color(0xffff3a2d),
                                                    borderRadius:  BorderRadius.circular(20*fem),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ),
         */

        ],
      ),
      bottomNavigationBar: RoundedBottomAppBar(token: token),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FF),
        title: Column(
          children: [
            //SizedBox(height: 54),
            MyHeader(),
          ],
        ),
        elevation: 0,
      )
    );

    Widget login = LoginScreen(signup: putsignupscreen, mainview: putmainviewscreen);
    Widget signup = SignupScreen(putloginscreen, putmainviewscreen);
    if (state == 0) return signup;
    else if (state == 1) return login;
    else {
      return mainview;
    }
  }
}




/*
class MyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //SizedBox(width: 27),
        SizedBox(width: 11),
        Image.asset("assets/images/Group 94.png", height: 29.47, width: 107.51),
        Spacer(),
        IconButton(
          icon: Image.asset("assets/images/Group 85.png", height: 18.29, width: 18.89),
          onPressed: () {},
        ),
        SizedBox(width: 6),
        CircleAvatar(
          //radius: 24,
          backgroundImage: AssetImage("assets/images/MYZHIK.png"),
        ),
        SizedBox(width: 11),
        //SizedBox(width: 27),
      ],
    );
  }
}
*/

//Left and right padding will be fixed as well as icon sizes
//Because of constant rounding 50% (for padding to make it not cut) and constant height of the bottom bar (for icons sizes)
//I don't think I should calculate new icon sizes that would be like 27x27
//Better stick with figma
//Moreover 30x30 is density independent, so we definitely don't need to dynamically calculate the size

//So with different height it is not a problem the app will scroll
//The problem is with different width
//Something should change its size

class RoundedBottomAppBar extends StatelessWidget {
  RoundedBottomAppBar({required this.token});
  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0, // Set the desired height for the bottom app bar
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
        child: BottomAppBar(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Image.asset("assets/images/Home_light.png", height: 30, width: 30),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset("assets/images/Calendar_duotone.png", height: 30, width: 30),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => CalendarScreen(token: token)));
                  },
                ),
                IconButton(
                  icon: Image.asset("assets/images/Group 82.png"),
                  iconSize: 61,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset("assets/images/Message.png", height: 30, width: 30),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ChatChoosingScreen(token: token)));
                  },
                ),
                IconButton(
                  icon: Image.asset("assets/images/setting.png"),
                  onPressed: () {
                    Query q = Query(complete: true);
                    q.specialization = "sp_12";
                    ChoosingScreenState.query = q;
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ChoosingScreen()));
                  },
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

