import 'dart:convert';
import 'package:ayoto/ChatScreen.dart';
import 'package:ayoto/ChoosingScreen.dart';
import 'package:ayoto/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:jwt_decoder/jwt_decoder.dart';


class SignUpRequest {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? confirmPassword;

  SignUpRequest(
      {this.name, this.email, this.phone, this.password, this.confirmPassword});

  SignUpRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['confirm_password'] = this.confirmPassword;
    return data;
  }
}
class LoginRequest {
  String? identifier;
  String? password;

  LoginRequest({this.identifier, this.password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['password'] = this.password;
    return data;
  }
}
class LoginReceived {
  bool? success;
  String? message;
  String? token;

  LoginReceived({this.success, this.message, this.token});

  LoginReceived.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['token'] = this.token;
    return data;
  }
}
class AuthHandler{
  Future<http.Response?>? signup(SignUpRequest s, ProfileCreation pc,Function success,Function error) async {
    String body = jsonEncode(s.toJson());

    log("signup body: " + body);

    var answer = await http.post(
      Uri.parse('https://api.ayoto.health/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    log("signup response: " + answer.body);
    log("signup code: " + answer.statusCode.toString());

    var decoded = jsonDecode(answer.body);
    if(answer.statusCode == 201){
      String userid = decoded["user_id"];
      int code = decoded['code'];

      MyHomePageState.userid = userid;

      answer = await http.post(
        Uri.parse('https://api.ayoto.health/auth/confirm'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: answer.body,
      );

      log("signup confirm response: " + answer.body);
      log("signup confirm code: " + answer.statusCode.toString());

      if(answer.statusCode == 200){
        await login(LoginRequest(identifier: s.phone,password: s.password), success, error);
        await createprofile(pc, success, error);

       }

    }else {
      log("ERROR" + answer.statusCode.toString());
    }
    return null;
  }
  Future<http.Response?>? createprofile(ProfileCreation pc, Function success,Function error) async {
    //String url = "https://api.ayoto.health/auth/";

    String body = jsonEncode(pc.toJson());

    log("signup body: " + body);

    var answer = await http.post(
      Uri.parse('https://api.ayoto.health/auth/profile/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + MyHomePageState.token
      },
      body: body,
    );

    log("createprofile response: " + answer.body);
    log("createprofile code: " + answer.statusCode.toString());

    var decoded = jsonDecode(answer.body);
    LoginReceived l = LoginReceived.fromJson(decoded);
    if(answer.statusCode == 201){
      MyHomePageState.token = l.token!;
      success();
    }else {
      log("ERROR" + answer.statusCode.toString());
      error();
    }
    return answer;
  }
  Future<http.Response?>? login(LoginRequest s, Function success,Function error) async {
    String body = jsonEncode(s.toJson());

    log("login body: " + body);

    var answer = await http.post(
      Uri.parse('https://api.ayoto.health/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    log("login response: " + answer.body);
    log("login code: " + answer.statusCode.toString());

    var decoded = jsonDecode(answer.body);
    if(answer.statusCode == 200){
      LoginReceived l = LoginReceived.fromJson(decoded);
      MyHomePageState.token = l.token!;

      Map<String, dynamic> decodedToken = JwtDecoder.decode(l.token!);
      print("decodedToken: ");
      print(decodedToken);
      MyHomePageState.userid = decodedToken["sub"];

      success();

    }else {
      log("ERROR" + answer.statusCode.toString());
      error();
    }
    return null;
  }
}
class ProfileCreation {
  String? dob;
  int? weight;
  int? height;
  double? latitude;
  double? longitude;
  String? sex;

  ProfileCreation(
      {this.dob,
        this.weight,
        this.height,
        this.latitude,
        this.longitude,
        this.sex});

  ProfileCreation.fromJson(Map<String, dynamic> json) {
    dob = json['dob'];
    weight = json['weight'];
    height = json['height'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    sex = json['sex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dob'] = this.dob;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['sex'] = this.sex;
    return data;
  }
}
