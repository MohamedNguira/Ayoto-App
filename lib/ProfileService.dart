import 'dart:convert';
import 'package:ayoto/ChatScreen.dart';
import 'package:ayoto/ChoosingScreen.dart';
import 'package:ayoto/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ProfileDetails {
  String? id;
  String? patientId;
  String? name;
  String? age;
  int? height;
  int? weight;
  double? latitude;
  double? longitude;
  String? sex;
  String? email;
  String? phone;

  ProfileDetails(
      {this.id,
        this.patientId,
        this.name,
        this.age,
        this.height,
        this.weight,
        this.latitude,
        this.longitude,
        this.sex,
        this.email,
        this.phone});

  ProfileDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    name = json['name'];
    age = json['age'];
    height = json['height'];
    weight = json['weight'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    sex = json['sex'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['name'] = this.name;
    data['age'] = this.age;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['sex'] = this.sex;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class ProfileService{

  Future<http.Response?>? getProfile(Function f) async {
    log("current-profile token: " + MyHomePageState.token);

    var answer = await http.get(
    Uri.parse('https://api.ayoto.health/auth/profile/current-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + MyHomePageState.token
      },
    );

    log("current-profile body: " + answer.body);
    log("current-profile code: " + answer.statusCode.toString());
    if(answer.statusCode == 200) {
      var decoded = jsonDecode(answer.body);
      ProfileDetails details = ProfileDetails.fromJson(decoded);
      f(details);
    }
    return null;
  }

  }