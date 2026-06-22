import 'package:flutter/material.dart';

class ColorPalettesScreen extends StatelessWidget {
  final palettes = [
    [Colors.red, Colors.orange, Colors.yellow],
    [Colors.blue, Colors.cyan, Colors.lightBlue],
    [Colors.purple, Colors.pink, Colors.deepPurple],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Palettes")),
      body: ListView.builder(
        itemCount: palettes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: palettes[index]
                    .map((c) => Container(width: 40, height: 40, margin: EdgeInsets.only(right: 8), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8))))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
