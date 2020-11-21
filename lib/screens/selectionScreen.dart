import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeromark/providers/topic.dart';
import 'package:zeromark/screens/ar.dart';

class SelectionScreen extends StatefulWidget {
  static const route = "/SelectionScreen";

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<Topic> _topics = [];
  
  @override
  void initState() {
    super.initState();
    _topics = Provider.of<TopicProvider>(context, listen: false).topicList;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select topic",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff343434),
      ),
      body: Container(
        child: _topics.length == 0
            ? Container()
            : Container(
                padding: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemCount: _topics.length,
                  itemBuilder: (ctx, i) => InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(ARPage.route, arguments: (i));
                    },
                    child: ListTile(
                      title: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text(_topics[i].topic),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
