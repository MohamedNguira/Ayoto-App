import 'package:ayoto/DateWidget.dart';
import 'package:ayoto/PriorityWidget.dart';
import 'package:ayoto/DoctorWidget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'AuthService.dart';


class SignupScreen extends StatefulWidget {
  SignupScreen(this.login,this.mainview,{super.key});
  Function login,mainview;
  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  ShapeDecoration selected = ShapeDecoration(
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 0.50, color: Color(0xFF03B2F0)),
      borderRadius: BorderRadius.circular(27),
    ),
  ), unselected = ShapeDecoration(
    color: Color(0xFF03B2F0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(27),
    ),
  );


  bool male = true,patient = true;
  String phonenumber = "", password = "",name ="",confirmpassword = "";
  String birthdate = "";
  int weight = 0,height = 0;
  String email = "";
  int index = 0;
  double latitude = 0, longitude = 0;
  String place = "";
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    List<Widget> pages = [
        Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text(
            "Let's get started!",
            style: TextStyle(
              color: Color(0xFF0B1533),
              fontSize: 24,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 30,),
          Text(
            'Full Name',
            style: TextStyle(
              color: Color(0xFF0B1533),
              fontSize: 16,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10,),
          TextField(onChanged: (String s){
            this.name = s;
          },style:TextStyle(
            color: Color(0xFF50535C),
            fontSize: 14,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w300,
          ),decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))
          ,
          SizedBox(height: 20,),
          Text(
            'Phone Number',
            style: TextStyle(
              color: Color(0xFF0B1533),
              fontSize: 16,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10,),
          TextField(obscureText: false,onChanged: (String s){
            this.phonenumber = s;
          },style:TextStyle(
            color: Color(0xFF50535C),
            fontSize: 14,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w300,
          ),decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))
          ,SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.start,children: [
            Text(
              'Password',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),SizedBox(width:100),
            Text(
              'Confirm Password',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],),
          SizedBox(height: 10,),
          Row(children: [
            SizedBox(width: 165,child: TextField(obscureText: true,onChanged: (String s){
              this.password = s;
            },style:TextStyle(
              color: Color(0xFF50535C),
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w300,
            ),decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))
              ,)
            ,SizedBox(width: 10,)
            ,SizedBox(width: 165,child: TextField(obscureText: true,onChanged: (String s){
              this.confirmpassword = s;
            },style:TextStyle(
              color: Color(0xFF50535C),
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w300,
            ),decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))
              ,)
          ],),
          Row(children: [
            Text('Already have an account? ',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 14,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(onPressed: (){
              super.widget.login();
            }, child: Text('Log in now',
              style: TextStyle(
                color: Color(0xFF03B2F0),
                fontSize: 14,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),)),
          ],),
        ],),
      Column(children: [
        Row(children: [Text(
          'I am a',
          style: TextStyle(
            color: Color(0xFF0B1533),
            fontSize: 24,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
          ),
        ),
          TextButton(onPressed: (){
            setState(() {
              male = true;
            });
          }, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: male?unselected:selected,
            child: Row(
              children: [
                Text(
                  'Male',
                  style: TextStyle(
                    color: !male?Color(0xFF03B2F0):Colors.white,
                    fontSize: 12,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

          )),
          TextButton(onPressed: (){setState(() {
            male = false;
          });}, child:   Container(

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: male?selected:unselected,
            child: Row(
              children: [
                Text(
                  'Female',
                  style: TextStyle(
                    color: male?Color(0xFF03B2F0):Colors.white,
                    fontSize: 12,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ))]),
        TextButton(onPressed: (){setState(() {
          patient = false;
        });}, child: patient?Image.asset("assets/select/doctor2.png"):Image.asset("assets/select/doctor1.png")),
        TextButton(onPressed: (){setState(() {
          patient = true;
        });}, child: patient?Image.asset("assets/select/patient1.png"):Image.asset("assets/select/patient2.png"))
        ,SizedBox(height: 20,),
        Align(alignment: Alignment.centerLeft,child: Text(

          'Residing in ',
          style: TextStyle(
            color: Color(0xFF0B1533),
            fontSize: 16,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
          ),
        ),),
        SizedBox(height: 10,),
        Container(
          width: 339,
          height: 48,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.82),
            ),
          ),
          child: Align(alignment: Alignment.center,child:Text(
            place,
            style: TextStyle(
              color: Color(0xFF50535C),
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w300,
            ),
          ) ),
        ),


      ],),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          'Some details remaining',
          style: TextStyle(
            color: Color(0xFF0B1533),
            fontSize: 24,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          'Birthdate',
          style: TextStyle(
            color: Color(0xFF0B1533),
            fontSize: 16,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
          ),
        ),
          SizedBox(height: 10,),
          TextButton( style: TextButton.styleFrom(
              padding: EdgeInsets.zero,

              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft),
              onPressed: () async {
              DateTime? time = await showDatePicker(context: context, initialDate: DateTime.timestamp(), firstDate: DateTime(1900), lastDate: DateTime.timestamp());
              setState(() {
                this.birthdate = time!.toIso8601String().substring(0,10);
                print(time.toIso8601String());
              });
          }, child: Container(
            child: Row(children: [SizedBox(width:10),
              Icon(Icons.calendar_today,color: Color(0xFF0B1533),),SizedBox(width:10),Text(birthdate,style: TextStyle(
                color: Color(0xFF50535C),
                fontSize: 14,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w300,
              ),)
            ],),
            width: 400,
            height: 60,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.82),
              ),
            ),
          )),
          SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.start,children: [
            Text(
              'Weight (kg)',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),SizedBox(width:100),
            Text(
              'Height (cm)',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],),
          SizedBox(height: 10,),
          Row(children: [
            SizedBox(width: 165,child: TextField(keyboardType: TextInputType.number,onChanged: (String s){
              this.weight = int.parse(s);
            },style:TextStyle(
              color: Color(0xFF50535C),
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w300,
            ),decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))
              ,)
            ,SizedBox(width: 10,)
            ,SizedBox(width: 165,child: TextField(keyboardType: TextInputType.number,onChanged: (String s){
              this.height = int.parse(s);
            },style:TextStyle(
              color: Color(0xFF50535C),
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w300,
            ),decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))
              ,)
          ],),
          SizedBox(height: 20,),
          Text(
            'Email',
            style: TextStyle(
              color: Color(0xFF0B1533),
              fontSize: 16,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10,),
          TextField(onChanged: (String s){
            this.email = s;
          },style:TextStyle(
            color: Color(0xFF50535C),
            fontSize: 14,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w300,
          ),decoration: InputDecoration(prefixIcon: Icon(Icons.mail),border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))

        ],)
    ];
    List<Widget> rectangle = [Image.asset("assets/scrolllow.png", scale: 80),Image.asset("assets/scrolllow.png", scale: 80),Image.asset("assets/scrolllow.png", scale: 80),Image.asset("assets/scrolllow.png", scale: 80),];
    rectangle[index] = Image.asset("assets/scrollhigh.png", scale: 80);
    TextButton proceed = TextButton(onPressed: (){
      if(index == 2) {
        AuthHandler().signup(SignUpRequest(password: password,
            name: name,
            confirmPassword: confirmpassword,
            email: email,
            phone: phonenumber), ProfileCreation(height: height,
            weight: weight,
            sex: male ? "male" : "female",
            dob: birthdate,
            latitude: latitude,
            longitude: longitude), super.widget.mainview, () {
          print("sign up error has occured");
        });
      }
      else {
        setState(() {
          controller.jumpToPage(index + 1);
        });
      }
    }, child: Container(
    width: index>0? 250:350,
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 15),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
    color: Color(0xFF577DF5),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(27),
    ),
    ),

    child: Center(child:Text(
    'Proceed',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w500,
    ),
    ),)));
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0xf5, 0xf7, 0xff, 1),
        body: Center(child:SizedBox(width: 345,child:SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/doctor1.png"),
              SizedBox(height: 20),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Image.asset("assets/ayoto.png",scale: 5,),SizedBox(width: 50,child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: rectangle,)
                ,)]),
              SizedBox(height: 20),
              Text(
                'Sign up',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF0B1533),
                  fontSize: 16,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(height: 430,child:  PageView(
                onPageChanged: (int i){
                  setState(() {
                    index = i;
                  });
                },
                  controller: controller,
                  children: pages
              ),)

              ,index>0?Row(children: [  TextButton(onPressed: (){
                setState(() {
                  controller.jumpToPage(index - 1);
                });
              }, child: Image.asset("assets/Back.png",scale:10)),proceed],):proceed],),)
        )
          ,) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition(Function f) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var x = await Geolocator.getCurrentPosition();
    print("Position is: " + x.longitude.toString() + " " + x.latitude.toString() + " " + x.altitude.toString());

    List<Placemark> placemarks = await placemarkFromCoordinates(x.latitude,x.longitude);
    print(placemarks[0].locality! + ", " + placemarks[0].country!);
    latitude = x.latitude;
    longitude = x.longitude;
    place = placemarks[0].locality! + ", " + placemarks[0].country!;
    f();
    return x;
  }
  @override
  void initState(){
     _determinePosition((){setState(() {

     });});
    super.initState();

  }
}
