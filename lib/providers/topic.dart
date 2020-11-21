import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Topic {
  String topic;
  String audioName;
  Color model;

  Topic(this.topic, this.audioName, this.model);
}

class TopicProvider with ChangeNotifier{
  List<Topic> _topics = [
    Topic("Sun", "sun.mp3", Colors.deepOrange),
    Topic("Jupiter", "jupiter.mp3", Color(0xffe36e4b)),
    Topic("Uranus", "uranus.mp3", Colors.blueGrey)
  ];

  List<Topic> get topicList {
    return _topics;
  }

  String audioPath(int i) {
    return "assets/audios/"+_topics[i].audioName;
  }

  Color modelPath(int i) {
    return _topics[i].model;
  }
}
