import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Topic {
  String name;
  String audio;
  String model;

  Topic(this.name, this.audio, this.model);
}

class TopicProvider with ChangeNotifier {
  List<Topic> _list = [];
  String url =
      "https://firestore.googleapis.com/v1/projects/zeromark-1704b/databases/(default)/documents/topics";

  List<Topic> get topicList {
    return _list;
  }

  void fetch() async {
    try {
      List<Topic> _tempList = [];
      await http.get(url).then((value) {
        final resp = jsonDecode(value.body);
        List res = resp['documents'];
        res.forEach((element) {
          _tempList.add(Topic(
              element['fields']['name']["stringValue"],
              element['fields']['audio']["stringValue"],
              element['fields']['model']["stringValue"]));
        });
      }).catchError((e) {
        throw (e);
      });
      _list = _tempList;
    } catch (e) {
      throw (e);
    }
  }

  Topic getTopic(int i) {
    return _list[i];
  }
}
