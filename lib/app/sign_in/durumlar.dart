import 'package:flutter/material.dart';

class Durumlar extends StatefulWidget {
  const Durumlar({Key? key}) : super(key: key);

  @override
  _DurumlarState createState() => _DurumlarState();
}

class _DurumlarState extends State<Durumlar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          "Hikayeler",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          GestureDetector(
            child: FlatButton(
              onPressed: () {},
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Durumlar>>(
        builder: (context, durumListesi) {
          if (!durumListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GestureDetector();
          }
        },
      ),
    );
  }
}
