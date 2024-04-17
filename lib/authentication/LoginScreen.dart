import 'dart:developer';

import 'package:ayoto/DateWidget.dart';
import 'package:ayoto/PriorityWidget.dart';
import 'package:ayoto/DoctorWidget.dart';
import 'package:flutter/material.dart';

import 'AuthService.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({super.key,required this.signup,required this.mainview});
  Function signup,mainview;
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {


  String phonenumber = "", password = "";
  bool remember = false;
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return Scaffold(
        backgroundColor: const Color.fromRGBO(0xf5, 0xf7, 0xff, 1),
        body: Center(child:SizedBox(width: 345,child:SingleChildScrollView(

          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/doctor1.png"),
          SizedBox(height: 20),

            Image.asset("assets/ayoto.png",scale: 5,),
          SizedBox(height: 20),
          Text(
            'Log in',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xFF0B1533),
              fontSize: 16,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
            ),
          ),
            SizedBox(height: 10,),
            Text(
              'Welcome Back!',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 24,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30,),
            Text(
              'Phone Number / Email',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10,),
            TextField(onChanged: (String s){
              this.phonenumber = s;
            },style:TextStyle(
              color: Color(0xFF50535C),
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w300,
            ),decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))
            ,
            SizedBox(height: 20,),
            Text(
              'Password',
              style: TextStyle(
                color: Color(0xFF0B1533),
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10,),
            TextField(obscureText: true,onChanged: (String s){
              this.password = s;
            },style:TextStyle(
              color: Color(0xFF50535C),
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w300,
            ),decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(30.82)),fillColor: Colors.white,filled: true))
            ,
            Row(children: [
              Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: remember, onChanged: (bool? b){
                setState(() {
                  remember = b!;
                });
              }),
              Text(
                'Remember Me',
                style: TextStyle(
                  color: Color(0xFF42495E),
                  fontSize: 12,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w400,
                ),
              )
            ],),
            Row(children: [
              Text('You don’t have an account? ',
                style: TextStyle(
                  color: Color(0xFF0B1533),
                  fontSize: 14,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextButton(onPressed: (){
                super.widget.signup();
              }, child: Text('Create one',
                style: TextStyle(
                  color: Color(0xFF03B2F0),
                  fontSize: 14,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                ),)),
            ],),

            TextButton(onPressed: (){
              AuthHandler().login(LoginRequest(password: password,identifier: phonenumber),super.widget.mainview, (){
                log("ERROR has occured while logging in");
              });

            }, child: Container(
                width: 345,
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
                  'Log in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,
                  ),
                ),)

            ))

          ],),)
        )
          ,) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
