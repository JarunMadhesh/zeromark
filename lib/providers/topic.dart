import 'package:flutter/cupertino.dart';

class Topic {
  String topic;
  String audioName;
  String modelName;

  Topic(this.topic, this.audioName, this.modelName);
}

class TopicProvider with ChangeNotifier{
  List<Topic> _topics = [
    Topic("Windmill", "wind.mp3", "Windmill.3mf"),
    Topic("Atoms", "atom.mp3", "atom.gltf"),
    Topic("Space shuttle", "Space.mp3", "Space.glb")
  ];

  List<Topic> get topicList {
    return _topics;
  }

  String audioPath(int i) {
    return "assets/audios/"+_topics[i].audioName;
  }

  String modelPath(int i) {
    return "assets/models/"+_topics[i].modelName;
  }
}
