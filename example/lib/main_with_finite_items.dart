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
        title: const Text('Items from -20 to 30'),
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedListView.builder(
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
                    button("jumpTo(-15px)", () => controller.jumpTo(-15)),
                    button("jumpTo(0px)", () => controller.jumpTo(0)),
                    button("jumpTo(50px)", () => controller.jumpTo(50)),
                  ],
                ),
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("animateTo(-30px)", () => controller.animateTo(-30)),
                    button("animateTo(50px)", () => controller.animateTo(50)),
                  ],
                ),
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("jumpToRelative(-250px)", () => controller.jumpToRelative(-250)),
                    button("jumpToRelative(40px)", () => controller.jumpToRelative(40)),
                  ],
                ),
                // ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button("animateToRelative(-250px)", () => controller.animateToRelative(-250)),
                    button("animateToRelative(40px)", () => controller.animateToRelative(40)),
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
      return (index < -20 || index > 30)
          ? null
          : Card(
              child: Container(
                height: heights[index % 527],
                color: (index == 0) ? Colors.red : Colors.green,
                child: Center(child: Text('ITEM $index')),
              ),
            );
    };
  }
}
