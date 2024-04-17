import 'package:ayoto/DateWidget.dart';
import 'package:ayoto/PriorityWidget.dart';
import 'package:ayoto/ProfileService.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';



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



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Future<String> futureUpcomingAppointments;


  String name = "Vladimir Santos";
  String date = "12/08/1980";
  String location = "Innopolis, Russia";
  String phone = "5981884884";

  int age = 42;
  bool male = true;
  TextStyle gray = TextStyle(
    color: Color(0xFF646D89),
    fontSize: 14,
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w400,
  );
  TextStyle black = TextStyle(
    color: Color(0xFF0B1533),
    fontSize: 14,
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w400,
  );

  @override
  void initState(){
    ProfileService().getProfile((ProfileDetails details){
      setState(() {
        name = details.name!;
        age = int.parse((details.age!).substring(0,2));
        //phone = details.phone!;
      });
    });

    futureUpcomingAppointments = fetchUpcomingAppointments();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    // ignore: prefer_const_constructors
    return Scaffold(
          body: SingleChildScrollView(child:Center(child:
        SizedBox(width: 350,child:
        Column(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(height: 50),
          Text(
            'My Profile',
            style: TextStyle(
              color: Color(0xFF0B1533),
              fontSize: 24,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20,),
          Row(children: [Container(
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: Image.asset("assets/images/MYZHIK.png").image,
                fit: BoxFit.fill,
              ),
              shape: OvalBorder(),
            ),
          ),SizedBox(width: 10,),Column(mainAxisAlignment:MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,children: [
            Text(
              name,
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 20,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              (male?"Male - ":"Female - ") + age.toString() + ' years old',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 12,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),

          ],)],),


            Text(
              'General information',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                height: 2,
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
              SizedBox(height: 150,child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name:',
                    style: gray,
                  ),
                  Text(
                    'Age:',
                    style: gray,
                  ),Text(
                    'Date of Birth:',
                    style: gray,
                  ),Text(
                    'Location:',
                    style: gray,
                  ),Text(
                    'Phone:',
                    style: gray,
                  ),Text(
                    'Gender:',
                    style: gray,
                  ),
                ],)),
              SizedBox(width: 70,),
              SizedBox(height: 150,child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: black,
                  ),
                  Text(
                    age.toString() + " years old",
                    style: black,
                  ),Text(
                    date,
                    style: black,
                  ),Text(
                    location,
                    style: black,
                  ),Text(
                    phone,
                    style: black,
                  ),Text(
                    male?"Male":'Female',
                    style: black,
                  ),
                ],))

            ],),
            SizedBox(height: 20,),
            Text(
              'Vitals:',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: 150,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
              decoration: ShapeDecoration(
                color: Color(0xFFC4E799),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.25),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Healthy',
                    style: TextStyle(
                      color: Color(0xFF0B1533),
                      fontSize: 14,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 82.98,
                    child: Text(
                      'You are keeping up with your monthly check',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF0B1533),
                        fontSize: 10,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Text(
              'Previous Analysis:',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20,),
            Align(alignment: Alignment.center,child: Text("No analysis done yet",style:gray),),
            Text(
              'Past medical checks:',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 20),



            FutureBuilder<String>(
              future: futureUpcomingAppointments,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //return Text(snapshot.data!.title);
                  List<dynamic> json = jsonDecode(snapshot.data!);

                  List<List<dynamic>> sortByMonth = List<List<dynamic>>.filled(12, []);
                  List<int> monthsNotEmpty = [];

                  for (int i = 0; i < json.length; i++) {
                    int month = int.parse(json[i]["date"].split("-")[1]) - 1;
                    monthsNotEmpty.add(month);

                    for (int j = 0; j < json[i]["data"].length; j++) {
                      sortByMonth[month].add(json[i]["data"][j]);
                    }
                  }

                  print(sortByMonth);

                  List<String> months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

                  return Container(
                    //constraints: BoxConstraints(maxHeight: 1000, maxWidth: 1000),
                    //width: 300,
                    //height: 300, //Controls the available space for the whole thing with tabs and labels
                    child: Column(
                      children: List.generate(monthsNotEmpty.length, (index) {
                        return IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                //height: 50,
                                alignment: Alignment.center,
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text(months[monthsNotEmpty[index]],
                                    style:  TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize:  14,
                                      fontWeight:  FontWeight.w600,
                                      height:  1.1,
                                      color:  Color(0xff0b1533),
                                    ),
                                  ),
                                ),
                                decoration:  BoxDecoration (
                                  borderRadius:  BorderRadius.circular(17.13),
                                  color:  Color(0xffcdf1fe),
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  children: List.generate(
                                    sortByMonth[monthsNotEmpty[index]].length,
                                    (appointmentIndex) {
                                      //Copy paste from 3rd screen

                                      dynamic appointmentData = sortByMonth[monthsNotEmpty[index]][appointmentIndex];
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


                                      //DateTime time = DateFormat('HH:mm').parse(appointmentData["start"]);
                                      ////String time12Hour = DateFormat('h:mm a').format(time);
                                      //appointmentData["startTimeFormatted"] = DateFormat('h:mm a').format(time);



                                      return Container( //DOCTOR TILE
                                        //width: double.infinity,
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
                                            /*
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
                                            ),*/
                                          ],
                                        )
                                      );
                                    }
                                  ),
                                )
                              )
                            ]
                          ),
                        );
                      })
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

        ],),)
     )));
  }
}




Future<String> fetchUpcomingAppointments() async {
  final response = await http.post(Uri.parse('https://api.ayoto.health/dataserver/appointments?includePast=true&includeFuture=false'),
      //body: '{"infermedicaId": "sp_12", "startDate": "2023-07-12", "endDate": "2023-07-15"}',
      body: '{"userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6"}',
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
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
