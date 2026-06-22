import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';

class TutorialsScreen extends StatelessWidget {
  final lessons = ["How to Draw Eyes", "Shading Basics", "Color Theory 101", "Drawing Hair", "Face Proportions"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tutorials")),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.play_circle),
              title: Text(lessons[index]),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
