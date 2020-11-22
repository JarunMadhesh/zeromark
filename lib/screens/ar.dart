import "package:arcore_flutter_plugin/arcore_flutter_plugin.dart";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:audioplayers/audioplayers.dart';
import 'package:zeromark/providers/fromFB.dart';

class ARPage extends StatefulWidget {
  static const route = "/ArPage";
  @override
  _ARPageState createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  ArCoreController arCoreController;
  bool flag = true;
  int index = -1;
  Topic topic;
  int count = 0;
  AudioPlayer advancedPlayer;
  bool _isPlaying = false;

  @override
  initState() {
    super.initState();
    advancedPlayer = AudioPlayer();
    topic = Topic("", "", "");
  }

  initAudioPlayer() {
    advancedPlayer.setUrl(topic.audio);
    advancedPlayer.setReleaseMode(ReleaseMode.STOP);
  }

  _onArKitViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _onPlaneTapHandler;
  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('Tapped on ${topic.name}')),
    );
  }

  void _onPlaneTapHandler(List<ArCoreHitTestResult> hits) {
    if (flag) {
      _addSphere(hits);
      flag = false;
      advancedPlayer.resume();
      _isPlaying = true;
    } else {
      arCoreController.removeNode(nodeName: topic.name);
      advancedPlayer.pause();
      _isPlaying = false;
      flag = true;
    }
    setState(() {});
  }

  _addSphere(List<ArCoreHitTestResult> hits) async {
    final hit = hits.first;

    await arCoreController.addArCoreNodeWithAnchor(
      ArCoreReferenceNode(
        name: topic.audio,
        objectUrl: topic.model,
        position: hit.pose.translation + vector.Vector3(0, 0, -1.5),
        scale: vector.Vector3(0.1, 0.1, 0.1),
        rotation: hit.pose.rotation,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    if (arCoreController != null) arCoreController.dispose();
    advancedPlayer.stop();
    if (advancedPlayer != null) advancedPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    index = ModalRoute.of(context).settings.arguments;
    topic = Provider.of<TopicProvider>(context).getTopic(index);
    if (count == 0) {
      initAudioPlayer();
      count += 1;
    }
    return index == -1
        ? Scaffold()
        : WillPopScope(
            onWillPop: () async {
              advancedPlayer.stop();
              return true;
            },
            child: Scaffold(
              body: Stack(children: [
                Container(),
                Center(
                  child: ArCoreView(
                    onArCoreViewCreated: _onArKitViewCreated,
                    enableTapRecognizer: true,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      if (flag) Text("Place the modal in a flat surface"),
                      Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                advancedPlayer.seek(Duration(seconds: -10));
                              },
                              icon: Text(
                                "-10s",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              iconSize: 60,
                            ),
                            _isPlaying
                                ? IconButton(
                                    icon: Icon(Icons.pause),
                                    iconSize: 60,
                                    onPressed: () {
                                      advancedPlayer.pause();

                                      _isPlaying = false;
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    iconSize: 60,
                                    onPressed: () {
                                      if (!flag) {
                                        advancedPlayer.resume();
                                        _isPlaying = true;
                                      }
                                    },
                                  ),
                            IconButton(
                              onPressed: () {
                                advancedPlayer.seek(Duration(seconds: 10));
                              },
                              icon: Text(
                                "+10s",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              iconSize: 60,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          );
  }
}
