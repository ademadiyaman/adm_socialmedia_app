import 'dart:ui';

import 'package:flutter/material.dart';

class Hakkimizda extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Hakkimizda();
}

class _Hakkimizda extends State<Hakkimizda> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            //color: Colors.white54,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white54,
            /* decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('images/bulut.jpg'),
                    fit: BoxFit.cover)),*/
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 330, sigmaY: 350),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 163),
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Image.asset("images/bluesend.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    "Blue Send Messenger",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Version 1.0",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
