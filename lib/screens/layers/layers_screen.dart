import 'package:flutter/material.dart';

class LayersScreen extends StatefulWidget {
  @override
  _LayersScreenState createState() => _LayersScreenState();
}

class _LayersScreenState extends State<LayersScreen> {
  List<String> layers = ["Layer 1", "Layer 2", "Layer 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Layers")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            layers.add("Layer ${layers.length + 1}");
          });
        },
        child: Icon(Icons.add),
      ),
      body: ReorderableListView(
        padding: EdgeInsets.all(10),
        children: [
          for (int i = 0; i < layers.length; i++)
            ListTile(
              key: ValueKey(layers[i]),
              title: Text(layers[i]),
              leading: Icon(Icons.layers),
              trailing: Icon(Icons.drag_handle),
            )
        ],
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = layers.removeAt(oldIndex);
            layers.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
