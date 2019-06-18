import 'dart:math';
import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  static IndexedScrollController controller = IndexedScrollController();

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(title: const Text('Indexed ListView')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: IndexedListView.builder(
              controller: controller,
              itemBuilder: itemBuilder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  color: Colors.blue,
                  child: const Text("-1000"),
                  onPressed: () => controller.jumpToIndex(controller.startIndex - 1000),
                ),
                MaterialButton(
                  color: Colors.blue,
                  child: const Text("RANDOM"),
                  onPressed: () => controller.jumpToIndex(Random().nextInt(100000)),
                ),
                MaterialButton(
                  color: Colors.blue,
                  child: const Text("+1000"),
                  onPressed: () => controller.jumpToIndex(controller.startIndex + 1000),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Function itemBuilder() {
    //
    final List<double> heights =
        new List<double>.generate(527, (i) => Random().nextInt(200).toDouble() + 30.0);

    return (BuildContext context, int index) {
      //
      return Card(
        child: Container(
          height: heights[index % 527],
          color: Colors.green,
          child: Center(child: Text('ITEM $index')),
        ),
      );
    };
  }
}
