import "package:arcore_flutter_plugin/arcore_flutter_plugin.dart";
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:zeromark/providers/topic.dart';

class ARPage extends StatefulWidget {
  static const route = "/ArPage";
  @override
  _ARPageState createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  ArCoreController arCoreController;
  AssetsAudioPlayer audioPlayer;
  bool flag = true;
  int index = -1;
  String title = "asd";
  String path = "";
  String path2 = "";
  Color _color = Colors.white;

  @override
  initState() {
    super.initState();
    audioPlayer = AssetsAudioPlayer();
  }

  initAudioPlayer() {
    audioPlayer.open(
      Audio(path),
    );
    audioPlayer.stop();
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
          AlertDialog(content: Text('onNodeTap on $name')),
    );
  }

  void _onPlaneTapHandler(List<ArCoreHitTestResult> hits) {
    if (flag) {
      _addSphere(hits);
      flag = false;
      audioPlayer.play();
    } else {
      arCoreController.removeNodeWithIndex(0);
      flag = true;
    }
    setState(() {});
  }

  _addSphere(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    // arCoreController.addArCoreNodeWithAnchor(
    //   ArCoreReferenceNode(
    //     name: "Modal",
    //     object3DFileName: path2,
    //     position: hit.pose.translation,
    //     rotation: hit.pose.rotation,
    //   ),
    // );
    final material = ArCoreMaterial(color: _color);
    final sphere = ArCoreSphere(materials: [material], radius: 0.2);
    final node = ArCoreNode(
        name: "Sun", shape: sphere, position: vector.Vector3(0, 0, -1));
    arCoreController.addArCoreNodeWithAnchor(
      ArCoreReferenceNode(
        name: "Etho",
        children: [node],
        position: hit.pose.translation,
        rotation: hit.pose.rotation,
      ),
    );
  }

  @override
  void dispose() {
    if (arCoreController != null) arCoreController.dispose();
    audioPlayer.stop();
    if (audioPlayer != null) audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    index = ModalRoute.of(context).settings.arguments;
    path = Provider.of<TopicProvider>(context).audioPath(index);
    _color = Provider.of<TopicProvider>(context).modelPath(index);

    initAudioPlayer();
    return index == -1
        ? Scaffold()
        : WillPopScope(
            onWillPop: () async {
              audioPlayer.stop();
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
                                audioPlayer.seekBy(Duration(seconds: -10));
                              },
                              icon: Text(
                                "-10s",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              iconSize: 60,
                            ),
                            PlayerBuilder.isPlaying(
                              player: audioPlayer,
                              builder: (context, isPlaying) {
                                if (isPlaying) {
                                  return IconButton(
                                    icon: Icon(Icons.pause),
                                    iconSize: 60,
                                    onPressed: () {
                                      audioPlayer.pause();
                                    },
                                  );
                                }
                                return IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  iconSize: 60,
                                  onPressed: () {
                                    audioPlayer.play();
                                  },
                                );
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                audioPlayer.seekBy(Duration(seconds: 10));
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
