import 'package:flutter/material.dart';
import 'package:zeromark/screens/selectionScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Zero mark",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff343434),
      ),
      body: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric( horizontal: 10),
                child: Text(
                  "New ERA learning app using AR",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff353535),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  "Learn the 3d world in 3d",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xff353535),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 30),
              Card(
                elevation: 40,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2.0, color: Color(0xff353535)),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width / 6),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SelectionScreen.route);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    alignment: Alignment.center,
                    child: Text(
                      "Let's go..",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height:30),
            ],
          ),
        ),
      ]),
    );
  }
}
