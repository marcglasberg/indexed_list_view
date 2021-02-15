import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatelessWidget {
  static IndexedScrollController controller = IndexedScrollController(initialIndex: 75);

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items count from -20 to 30'),
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedListView.builder(
              minItemCount: -20,
              maxItemCount: 30,
              controller: controller,
              itemBuilder: itemBuilder(),
            ),
          ),
          Container(height: 3.0, color: Colors.black),
          Container(
            color: Colors.grey[800],
            child: Column(
              children: [
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("jumpToIndex(-42)", () => controller.jumpToIndex(-42)),
                    button("jumpToIndex(750000)", () => controller.jumpToIndex(750000)),
                  ],
                ),
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("animateToIndex(-42)", () => controller.animateToIndex(-42)),
                    button("animateToIndex(750000)", () => controller.animateToIndex(750000)),
                  ],
                ),
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("jumpTo(-15)", () => controller.jumpTo(-15)),
                    button("jumpTo(0)", () => controller.jumpTo(0)),
                    button("jumpTo(50)", () => controller.jumpTo(50)),
                  ],
                ),
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("animateTo(-30)", () => controller.animateTo(-30)),
                    button("animateTo(50)", () => controller.animateTo(50)),
                  ],
                ),
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("jumpToRelative(-250)", () => controller.jumpToRelative(-250)),
                    button("jumpToRelative(40)", () => controller.jumpToRelative(40)),
                  ],
                ),
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("animateToRelative(-250)", () => controller.animateToRelative(-250)),
                    button("animateToRelative(40)", () => controller.animateToRelative(40)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget button(String text, VoidCallback function) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: RawMaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.all(10.0),
          fillColor: Colors.blue,
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 30.0),
          onPressed: function,
          child: Text(text, style: const TextStyle(fontSize: 12)),
        ),
      );

  /// It only provides items between indexes -20 and 30.
  IndexedWidgetBuilderOrNull itemBuilder() {
    //
    final List<double> heights =
        List<double>.generate(527, (i) => Random().nextInt(200).toDouble() + 30.0);

    return (BuildContext context, int index) {
      return Card(
        child: Container(
          height: heights[index % 527],
          color: (index == 0) ? Colors.red : Colors.green,
          child: Center(child: Text('ITEM $index')),
        ),
      );
    };
  }
}
