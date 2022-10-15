import 'package:flutter/material.dart';

class OrnekPage1 extends StatelessWidget {
  const OrnekPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OrnekPage1"),
      ),
      body: Center(
        child: Text("Ornek Page1 Sayfası"),
      ),
    );
  }
}
