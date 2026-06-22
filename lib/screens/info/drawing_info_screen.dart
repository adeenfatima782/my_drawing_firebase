import 'package:flutter/material.dart';

class DrawingInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drawing Info")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info("Resolution", "1080 x 1080"),
            _info("Layers", "3"),
            _info("Created On", "2 Dec 2025"),
            _info("Stroke Count", "2341"),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title, style: TextStyle(fontSize: 18)), Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))],
      ),
    );
  }
}
