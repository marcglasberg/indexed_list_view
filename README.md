# indexed_list_view

Similar to a ListView, but lets you programmatically jump to any item, by index.
Currently, the list is always infinite both to positive and negative indexes.
In other words, it can be scrolled indefinitely both to the top and to the bottom.

## Usage

### Import the package

First, add indexed_list_view [as a dependency](https://pub.dartlang.org/packages/indexed_list_view#-installing-tab-) in your pubspec.yaml

Then, import it:

    import 'package:indexed_list_view/indexed_list_view.dart';

### Use the package

First, create an indexed scroll controller:

    IndexedScrollController controller = IndexedScrollController();

Then, create the indexed list view, and pass that controller:

    IndexedListView.builder(controller: controller, itemBuilder: itemBuilder);

To jump, use the controller's `jumpToIndex` method:

    controller.jumpToIndex(10000);

The jump is cheap, since it doesn't need to build all widgets between the old and new positions.
However, if all you need is an infinite list, without jumps, there is no need to even define a controller.

Hopefully this widget will become obsolete when Flutter's original ListView allows for negative
indexes and for indexed jumps. See: https://github.com/flutter/flutter/issues/12319

Don't forget to check the [example tab](https://pub.dartlang.org/packages/indexed_list_view#-example-tab-).

# TODO

- [X] Jump to index.
- [X] Infinite list (both up and down).
- [ ] Allow passing lower and upper bounds, so that the list doesn't need to be infinite.
- [ ] Allow for scrollbars (makes sense in the finite case only).
- [ ] Make the list trackable, so that you know which item indexes are visible in the top and bottom
      of the viewport.
- [ ] Fixing a bug where under certain rare circumstances the user can't stop a ballistic scroll
      until it stops by itself.

This package got some ideas from [Collin Jackson's code in StackOverflow](https://stackoverflow.com/questions/44468337/how-can-i-make-a-scrollable-wrapping-view-with-flutter).

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
