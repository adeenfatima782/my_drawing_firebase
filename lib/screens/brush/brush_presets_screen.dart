import 'package:flutter/material.dart';

class BrushPresetsScreen extends StatelessWidget {
  final brushes = ["Pencil", "Marker", "Watercolor", "Airbrush", "Calligraphy"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Brush Presets")),
      body: ListView.builder(
        itemCount: brushes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(brushes[index]),
            leading: Icon(Icons.brush),
            trailing: Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}
