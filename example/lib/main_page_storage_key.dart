import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatefulWidget {
  static IndexedScrollController controller = IndexedScrollController();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hide = false;
  bool withKey = false;

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('IndexedListView with PageStorageKey'),
        backgroundColor: Colors.grey[800],
      ),
      body: hide
          ? SizedBox()
          : Column(
              children: [
                Expanded(
                  child: IndexedListView.builder(
                    key: withKey ? PageStorageKey("MyKey") : null,
                    controller: HomePage.controller,
                    itemBuilder: itemBuilder(),
                  ),
                ),
                Container(height: 3.0, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RawMaterialButton(
                      padding: const EdgeInsets.all(12.0),
                      fillColor: withKey ? Colors.blue : Colors.blue.withOpacity(.5),
                      child: Text("PageStorageKey ${withKey ? "On" : "Off"}",
                          style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        setState(() {
                          withKey = !withKey;
                        });
                      },
                    ),
                    RawMaterialButton(
                      padding: const EdgeInsets.all(12.0),
                      fillColor: Colors.blue,
                      child: Text("Rebuild", style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        setState(() {
                          hide = true;
                          Timer(Duration(milliseconds: 100), () {
                            setState(() {
                              hide = false;
                            });
                          });
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Function itemBuilder() {
    //
    final List<double> heights =
        new List<double>.generate(527, (i) => Random().nextInt(200).toDouble() + 30.0);

    return (BuildContext context, int index) => Card(
          child: Container(
            height: heights[index % 527],
            color: (index == 0) ? Colors.red : Colors.green,
            child: Center(child: Text('ITEM $index')),
          ),
        );
  }
}
