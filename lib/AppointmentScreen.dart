import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'FlutterMapAssets.dart';
import 'MyHeader.dart';
//import 'ButtonBottomAppBar.dart';
import 'CurrentPriorityText.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;




String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}



class AppointmentScreen extends StatefulWidget {
  AppointmentScreen({super.key, required this.date, required this.weekday, required this.json}) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat("MMMM yyyy").format(dateTime);

    String day = DateFormat("d").format(dateTime);
    String suffix = _getDaySuffix(int.parse(day));
    convertedDate = "$day$suffix $formattedDate";
    
    
    if (json["doctorAddress"] != null && json["doctorAddress"].trim().isNotEmpty) {
      List<String> splitAddress = json["doctorAddress"].split(", ");
      doctorCity = splitAddress.last.split("-")[0];

      splitAddress.removeLast();
      shortAddress = splitAddress.join(", ");
    }


    if (json["daysRemaining"] != null) {
      if (json["daysRemaining"] == 0 || json["daysRemaining"] == "0") {
        daysRemainingText = "<1 Day remaining";
      } else if (json["daysRemaining"] == 1 || json["daysRemaining"] == "1") {
        daysRemainingText = "1 Day remaining";
      } else {
        daysRemainingText = json["daysRemaining"] + " Days remaining";
      }
    }

/*
    print("test");
    print(0 == "0"); //false
    print(3 > "2"); //error
    print("2" > 1); //error
    int testInt = 5;
    print(int.parse(testInt)); //error

 */
  }

  final String date;
  final String weekday;
  final dynamic json;

  late String convertedDate;
  String shortAddress = "";
  late String doctorCity;
  String daysRemainingText = "";
  /*
  const AppointmentScreen({
    super.key,
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

   */

  @override
  State<AppointmentScreen> createState() => AppointmentScreenState();
}




class MyAlert extends StatefulWidget{
  MyAlert({super.key, required this.doctorId, required this.start, required this.finish});

  final String doctorId;
  final String start;
  final String finish;

  State<MyAlert> createState() => MyAlertState();
}

class MyAlertState extends State<MyAlert>{

  bool isLoading = true;
  //This is not passed to contructor, so this is part of state, and it actually is because it is state of loading the response
  bool successfullyLoaded = true;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isLoading ? 'Booking in process...' : (successfullyLoaded ? "Booked!" : "Error while booking"),
        style: TextStyle(
          fontFamily: 'Outfit',
          //fontSize:  16,
          //fontWeight:  FontWeight.w600,
          //height:  1.1,
          color:  Color(0xff152d37),
        )
      ),
      content: AlertAJAXContent(doctorId: widget.doctorId, start: widget.start, finish: widget.finish, updateData: _updateData)
    ); //Looks like I can combine two classes by I cannot because I need to update the state of this class only from the parent class
  }

  void _updateData(bool isLoading, bool successfullyLoaded) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      this.isLoading = isLoading;
      this.successfullyLoaded = successfullyLoaded;
    }));
  }
}




class AlertAJAXContent extends StatelessWidget {
  AlertAJAXContent({super.key, required this.doctorId, required this.start, required this.finish, required this.updateData});

  final String doctorId;
  final String start;
  final String finish;
  final Function updateData;



  //Future<String> fetchCreatingAppointment(String doctorId, String start, String finish) async {
  Future<String> fetchCreatingAppointment() async {
    //GOOD REQUEST TO THE ACTUAL SERVER
    final response = await http.post(Uri.parse('https://api.ayoto.health/dataserver/appointment'),
        body: '{"userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6", "doctorId": "' + doctorId + '", "start": "' + start +  '", "finish": "' + finish +  '"}',
        headers: {
          "Content-Type": "application/json"
        }
    );

    print(response);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return response.body;
    } else if (response.statusCode == 409) {
      throw Exception('This timeslot is already booked');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Unknown error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchCreatingAppointment(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          updateData(false, true);
          return Text(snapshot.data!,
            style: TextStyle(
              fontFamily: 'Outfit',
              //fontSize:  16,
              //fontWeight:  FontWeight.w600,
              //height:  1.1,
              color:  Color(0xff152d37),
            ),
          );
        } else if (snapshot.hasError) {
          updateData(false, false);
          return Text(snapshot.error.toString().replaceAll("Exception: ", ""),
            style: TextStyle(
              fontFamily: 'Outfit',
              //fontSize:  16,
              //fontWeight:  FontWeight.w600,
              //height:  1.1,
              color:  Color(0xff152d37),
            ),
          );
        }

        // By default, show a loading spinner.
        //return const CircularProgressIndicator();
        return Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          //padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: CircularProgressIndicator()
        );

        /*const Text(
        'A dialog is a type of modal window that\n'
        'appears in front of app content to\n'
        'provide critical information, or prompt\n'
        'for a decision to be made.',
      ),*/
        /*
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Disable'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Enable'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      */
      }
    );
  }
}






class AppointmentScreenState extends State<AppointmentScreen> {
  //late Future<String> futureCreatingAppointment;

  @override
  Widget build(BuildContext context) {

    // ignore: prefer_const_constructors
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0xf5, 0xf7, 0xff, 1),
        bottomNavigationBar: Container(
          height: 48,
          margin: EdgeInsets.fromLTRB(27, 0, 27, 10),
          child: ElevatedButton(
            onPressed: () {
              String start = widget.date + "T" + widget.json["startTime"] + ".000Z";
              String finish = widget.date + "T" + widget.json["finishTime"] + ".000Z";
              //futureCreatingAppointment = fetchCreatingAppointment(widget.json["doctorUUID"], start, finish);

              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return MyAlert(doctorId: widget.json["doctorUUID"], start: start, finish: finish);
                },
              );/*.then((val){
                setState(() {
                  isLoading = true;
                  successfullyLoaded = true;
                });
              });*/

              //This is not needed as the class is getting created new every time.
              //Nice

              //And looks like the state was not being set not because it was being set inside builder
              //But because it was trying to update the state of the FutureBuilder itself
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
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 17),

              CurrentPriorityText(),

              SizedBox(height: 20), //FIGMA HAS 50 HERE
              Text(
                'Appointment Details:',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize:  16,
                  fontWeight:  FontWeight.w600,
                  height:  1.1,
                  color:  Color(0xff152d37),
                ),
              ),

              //So in figma the doctor avatar lies 3 pixels upper, but this cannot really be seen, but makes the layout harder
              //I made it easier

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.json["doctorName"],
                        //'Dr. Istvan Emre',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize:  18,
                          fontWeight:  FontWeight.w600,
                          height:  1.1,
                          color:  Color(0xff152d37),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        //widget.json["doctorSpecialization"] + " - " + widget.json["doctorCity"],
                        widget.json["doctorSpecialization"] + " - " + widget.doctorCity,
                        //'Cardiologist - Debrecen',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize:  14,
                          //fontWeight:  FontWeight.w400,
                          height:  1.1,
                          color:  Color(0xff152d37),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/DED.png"),
                    radius: 40,
                  ),
                ],
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  Container(
                    //margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    width: 60,
                    height: 70,
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xffd4ddfc),
                    ),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.date.split("-")[2],
                          //widget.date.split(" ")[0].substring(0, widget.date.split(" ")[0].length - 2),
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
                          widget.weekday[0] + widget.weekday.toString().substring(1, 3).toLowerCase(),
                          //widget.weekday.substring(0, 3),
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
                  ),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.weekday[0] + widget.weekday.toString().substring(1).toLowerCase() + " " + widget.convertedDate,
                        //widget.weekday + " " + widget.date,
                        //'Monday 10th April 2023',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize:  16,
                          //fontWeight:  FontWeight.w400,
                          height:  1.1,
                          color:  Color(0xff152d37),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.json["startTimeFormatted"],
                        //'8:00 AM',
                        textAlign:  TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize:  14,
                          fontWeight:  FontWeight.w600,
                          height:  1.1,
                          color:  Color(0xff152d37),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        //widget.json["daysRemaining"] != null && widget.json["daysRemaining"].toString().trim().isNotEmpty
                        //widget.json["daysRemaining"] != null ? (widget.json["daysRemaining"] + ' remaining') : "",
                        widget.daysRemainingText,
                        //'3 Days remaining',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize:  12,
                          //fontWeight:  FontWeight.w400,
                          height:  1.1,
                          color:  Color(0xffff532d),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30),
              Text(
                widget.shortAddress + (widget.json["distanceAway"] != null ? (" (" + widget.json["distanceAway"] + " km)") : ""),
                //widget.json["doctorAddress"].split(", ").sublist(0, widget.json["doctorAddress"].split(", ").length - 2),
                //widget.json["doctorStreetOrHospitalName"] + ", " + widget.json["doctorCity"] + " (" + widget.json["distanceAway"] + " km)",
                //'Pannon Hospital, 4032 Debrecen (3km away)',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  //fontWeight: FontWeight.w400,
                  height: 1.1,
                  color:  Color(0xff152d37),
                ),
              ),
              SizedBox(height: 9),
              Container(
                height: 173,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(widget.json["latitude"], widget.json["longitude"]), //LatLng(51.509364, -0.128928),
                    zoom: 9.2,
                  ),
                  nonRotatedChildren: [
                    /*
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          //onTap: () => launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&travelmode=driving&layer=traffic&destination=51.509364,-0.128928'),
                          onTap: () => launchUrl(Uri.parse('geo:37.7749,-122.4192?q=Souvla'), //GOOD BECAUSE IT WILL ALSO SHOW THE ADDRESS IN THE SEARCH QUERY
                              //AND WILL MARK IT, IF YOU USE JUST IT JUST MARK COORDINATES
                          //onTap: () => launchUrl(Uri.parse('geo:37.7749,-122.4192?q=37.7749,-122.4192 (label)'),
                          mode: LaunchMode.externalApplication),
                          //onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                        ),
                      ],
                    ),*/

                    FlutterMapZoomButtons(
                      minZoom: 1,
                      maxZoom: 18,
                      mini: true,
                      padding: 2.0,
                      alignment: Alignment.topRight,
                      zoomInColor: Colors.white,
                      zoomOutColor: Colors.white,
                      zoomInIcon: Icons.add,
                      zoomOutIcon: Icons.remove,
                    ),
                    ScaleLayerWidget(
                        options: ScaleLayerPluginOption(
                      lineColor: Colors.black54,
                      lineWidth: 2,
                      textStyle:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                      padding: const EdgeInsets.all(10),
                    )),
                  ],
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      rotate: false,
                      anchorPos: AnchorPos.align(AnchorAlign.top),
                      markers: [
                        //buildPin(const LatLng(
                        //    51.51868093513547, -0.12835376940892318)),
                        //buildPin(
                        //    const LatLng(53.33360293799854, -6.284001062079881)),
                        Marker(
                          point: LatLng(widget.json["latitude"], widget.json["longitude"]), //const LatLng(51.509364, -0.128928),
                          width: 40,
                          height: 40,
                          anchorPos: AnchorPos.align(AnchorAlign.top),
                          builder: (context) => Image.asset("assets/images/pngwing.com.png")
                        ),
                        /*
                        Marker(
                          point: const LatLng(
                              47.18664724067855, -1.5436768515939427),
                          rotate: false,
                          builder: (context) =>
                              const ColoredBox(color: Colors.black),
                        ),*/
                      ],
                    ),
                    //MarkerLayer(
                    //  markers: customMarkers,
                    //  rotate: counterRotate,
                    //  anchorPos: AnchorPos.align(anchorAlign),
                    //),
                  ],
                )
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 33.96,
                      child: OutlinedButton(
                        //onPressed: () => launchUrl(Uri.parse('geo:' + widget.json["longitude"].toString() + ',' + widget.json["latitude"].toString() + "?q=" + widget.json["longitude"].toString() + ',' + widget.json["latitude"].toString() + "(" + widget.shortAddress + ")")), // + '?q=' + widget.shortAddress)),
                        //Like this it might now show very correct location, but it will mark the marker with the correct address
                        //onPressed: () => launchUrl(Uri.parse('geo:' + widget.json["longitude"].toString() + ',' + widget.json["latitude"].toString() + "?q=Hospital")),
                        //This shows lots of hospitals
                        onPressed: () => launchUrl(Uri.parse('geo:' + widget.json["latitude"].toString() + ',' + widget.json["longitude"].toString() + '?q=' + widget.shortAddress)),

                        child: Row( //With query sometimes it shows even different country (ex: 1/1, Mirpur Road, Kallyanpur on yandex maps)
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/google-map-icon.png", width: 23, height: 34.5),
                            SizedBox(width: 10),
                            Text(
                              'Open map',
                              style:  TextStyle(
                                fontFamily: 'Outfit',
                                fontSize:  14,
                                fontWeight:  FontWeight.w500,
                                height:  1.1,
                                color:  Color(0xff03b2f0),
                              ),
                            ),
                          ],
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
                  ),
                  //Spacer(),
                  SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      height: 33.96,
                      child: OutlinedButton(
                        onPressed: () => launchUrl(Uri.parse('tel:0123456789')),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/Vector2.png", width: 17.96, height: 17.96),
                            SizedBox(width: 10),
                            Text(
                              'Call doctor',
                              style:  TextStyle(
                                fontFamily: 'Outfit',
                                fontSize:  14,
                                fontWeight:  FontWeight.w500,
                                height:  1.1,
                                color:  Color(0xff03b2f0),
                              ),
                            )
                          ],
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
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
