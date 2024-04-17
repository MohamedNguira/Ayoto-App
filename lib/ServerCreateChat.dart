import 'dart:convert';
import 'package:ayoto/ChatScreen.dart';
import 'package:ayoto/ChoosingScreen.dart';
import 'package:ayoto/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatCreator {
  String? message;

  ChatCreator({this.message});

  ChatCreator.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}

class ChatHandler{
  ChatHandler({required this.token});

  final String token;

  Future<http.Response?>? createchat(String msg,Function f) async {
    print(token);

    var map = <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + token
          };

    print(map);

    var thisJson = jsonEncode(ChatCreator(message: msg).toJson());

    print(thisJson);

    String url = "https://diagnosis-app-ob5xb.ondigitalocean.app";
    var answer = await http.post(
      Uri.parse('https://api.ayoto.health/diagnosis/create-chat'),
      headers: map,
      body: thisJson,
    );
    print(answer.body);
    var decoded = jsonDecode(answer.body);
    Query q = Query.fromJson(decoded);

    if(q.complete) {
      ChatScreenState.finished = true;
      ChoosingScreenState.query = q;
    }
    f(q);
    return null;
  }

  Future<http.Response?>? submitevidence(SubmitEvidence evidence,Function f) async {
    String url = "https://diagnosis-app-ob5xb.ondigitalocean.app";

    print(token);

    var answer = await http.post(
      Uri.parse('https://api.ayoto.health/diagnosis/submit-evidence'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(evidence.toJson()),
    );
    print(answer.body);
    var decoded = jsonDecode(answer.body);
    Query q = Query.fromJson(decoded);

    if(q.complete) {
      ChatScreenState.finished = true;
      ChoosingScreenState.query = q;
    }
    f(q);
    return null;
  }


}
class Query {
  String? id;
  bool complete = false;
  String? specialization;
  int? severity;
  String? recommendedChannel;
  String? type;
  Question? question;

  Query(
      {this.id,
        required this.complete,
        this.specialization,
        this.severity,
        this.recommendedChannel,
        this.type,
        this.question});

  Query.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complete = json['complete'];
    specialization = json['specialization'];
    severity = json['severity'];
    recommendedChannel = json['recommended_channel'];
    type = json['type'];
    question = json['question'] != null
        ? new Question.fromJson(json['question'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['complete'] = this.complete;
    data['specialization'] = this.specialization;
    data['severity'] = this.severity;
    data['recommended_channel'] = this.recommendedChannel;
    data['type'] = this.type;
    if (this.question != null) {
      data['question'] = this.question!.toJson();
    }
    return data;
  }
}

class Question {
  String? label;
  List<Evidence>? evidences;

  Question({this.label, this.evidences});

  Question.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['evidences'] != null) {
      evidences = <Evidence>[];
      json['evidences'].forEach((v) {
        evidences!.add(new Evidence.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.evidences != null) {
      data['evidences'] = this.evidences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Evidence {
  String? id;
  String? label;

  Evidence({this.id, this.label});

  Evidence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}

class SubmitEvidence {
  String? id;
  String? message;
  List<EvidenceChoice>? evidences;

  SubmitEvidence({this.id, this.message, this.evidences});

  SubmitEvidence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    if (json['evidences'] != null) {
      evidences = <EvidenceChoice>[];
      json['evidences'].forEach((v) {
        evidences!.add(new EvidenceChoice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    if (this.evidences != null) {
      data['evidences'] = this.evidences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class EvidenceChoice {
  String? id;
  String? choiceId;

  EvidenceChoice({this.id, this.choiceId});

  EvidenceChoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    choiceId = json['choice_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['choice_id'] = this.choiceId;
    return data;
  }
}