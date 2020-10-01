[![pub package](https://img.shields.io/pub/v/indexed_list_view.svg)](https://pub.dartlang.org/packages/indexed_list_view)

# indexed_list_view

Similar to a ListView, but lets you **programmatically jump to any item**, by index.
The index jump happens **instantly**, no matter if you have millions of items.

Limitation: The list is always **_infinite_** both to positive and negative indexes.
In other words, it can be scrolled indefinitely both to the top and to the bottom.

You can define index bounds by giving it a `minItemCount` and `maxItemCount`, 
but this will not prevent the list from scrolling indefinitely.
When showing items out of the index bounds, or when your `itemBuilder` returns `null`, 
it will ask the `emptyItemBuilder` to create an "empty" item to be displayed instead. 
As default, this will return empty containers.

## Usage

### Import the package

Add indexed_list_view [as a dependency](https://pub.dartlang.org/packages/indexed_list_view#-installing-tab-) 
in your `pubspec.yaml` file, and then import it:

    import 'package:indexed_list_view/indexed_list_view.dart';

### Use the package

First, create an indexed scroll controller:

    var controller = IndexedScrollController();
    
Optionally, you may setup an initial index and/or initial scroll offset:

    var controller = IndexedScrollController(
        initialIndex: 75,
        initialScrollOffset : 30.0);    

Then, create the indexed list view, and pass it the controller:

    IndexedListView.builder(
        controller: controller, 
        itemBuilder: itemBuilder);

There is also the separated constructor, same as `ListView.separated`:

    IndexedListView.separated(
        controller: controller, 
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder);

To jump, use the controller methods like `jumpToIndex` :

    controller.jumpToIndex(10000);

## Details

The IndexedScrollController has not only an `offset` in pixels, 
but also an `origin-index` that indicates which item is considered to be at the offset position `0.0`.

So there are two ways for you to move the list programmatically: 
You can change only the `offset`, 
or else change the `originIndex` and the `offset` at the same time.

To change the `originIndex` you make an "index jump". 
This jump is cheap, since it doesn't need to build all widgets between the old and new positions.
It will just change the origin.

If you want to move the list programmatically you must create a scroll controller of type `IndexedScrollController` 
and pass it in the list constructor.
However, if all you need is an infinite list without jumps, then there is no need to even create a controller.

You move the list programmatically by calling the controller methods.   

## Controller Methods

1. `jumpToIndex(index)`

    The is the most common method for you to use.
    It jumps the origin-index to the given index, and the scroll-position to 0.0.

2. `jumpToIndexAndOffset(index, offset)`

   Jumps the origin-index to the given index, and the scroll-position to offset, without animation.
  
3. `animateToIndex(index)`

   If the current origin-index is already the same as the given index,
   animates the position from its current value to the offset position
   relative to the origin-index.    
   
   However, if the current origin-index is different from the given index,
   this will jump to the new index, without any animation.
   In general, there are never animations when the index changes.

2. `animateToIndexAndOffset(index, offset)`

   Same as `animateToIndex()` but also lets you specify the new offset.
  
4. `jumpTo(offset)`

    Goes to origin-index "0", 
    and then jumps the scroll position from its current value to the given offset,
    without animation.

4. `animateTo(offset)`

   If the current origin-index is already "0",
   animates the position from its current value to the offset position.
   
   However, if the current origin-index is different from "0",
   this will jump to index "0" and the given offset, without any animation.
   In general, there are never animations when the index changes.

5. `jumpToWithSameOriginIndex(offset)`
   
   Jumps the offset, relative to the current origin-index.

6. `animateToWithSameOriginIndex(offset)`

   Animates the offset, relative to the current origin-index.

7. `jumpToRelative(offset)`

   Jumps the offset, adding or subtracting from the current offset.
   It keeps the same origin-index.

8. `animateToRelative(offset)`

   Animates the offset, adding or subtracting from the current offset.
   It keeps the same origin-index.

Don't forget to check the [example tab](https://pub.dartlang.org/packages/indexed_list_view#-example-tab-).
It shows an infinite list of items of different heights, and you may tap buttons to
run some of the methods explained above.

********

Hopefully this widget will become obsolete when Flutter's original ListView allows for negative
indexes and for indexed jumps. See: https://github.com/flutter/flutter/issues/12319

*This package got some ideas from [Collin Jackson's code in StackOverflow](https://stackoverflow.com/questions/44468337/how-can-i-make-a-scrollable-wrapping-view-with-flutter),
and uses lots of code from [Simon Lightfoot's infinite_listview](https://pub.dev/packages/infinite_listview).* 

*The Flutter packages I've authored:* 
* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/provider_for_redux">provider_for_redux</a>
* <a href="https://pub.dev/packages/i18n_extension">i18n_extension</a>
* <a href="https://pub.dev/packages/align_positioned">align_positioned</a>
* <a href="https://pub.dev/packages/network_to_file_image">network_to_file_image</a>
* <a href="https://pub.dev/packages/image_pixels">image_pixels</a>
* <a href="https://pub.dev/packages/matrix4_transform">matrix4_transform</a> 
* <a href="https://pub.dev/packages/back_button_interceptor">back_button_interceptor</a>
* <a href="https://pub.dev/packages/indexed_list_view">indexed_list_view</a> 
* <a href="https://pub.dev/packages/animated_size_and_fade">animated_size_and_fade</a>
* <a href="https://pub.dev/packages/assorted_layout_widgets">assorted_layout_widgets</a>
* <a href="https://pub.dev/packages/weak_map">weak_map</a>

*My Medium Articles:*
* <a href="https://medium.com/flutter-community/https-medium-com-marcglasberg-async-redux-33ac5e27d5f6">Async Redux: Flutter’s non-boilerplate version of Redux</a> (versions: <a href="https://medium.com/flutterando/async-redux-pt-brasil-e783ceb13c43">Português</a>)
* <a href="https://medium.com/flutter-community/i18n-extension-flutter-b966f4c65df9">i18n_extension</a> (versions: <a href="https://medium.com/flutterando/qual-a-forma-f%C3%A1cil-de-traduzir-seu-app-flutter-para-outros-idiomas-ab5178cf0336">Português</a>)
* <a href="https://medium.com/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2">Flutter: The Advanced Layout Rule Even Beginners Must Know</a> (versions: <a href="https://habr.com/ru/post/500210/">русский</a>)

*My article in the official Flutter documentation*:
* <a href="https://flutter.dev/docs/development/ui/layout/constraints">Understanding constraints</a>

---<br>_Marcelo Glasberg:_<br>
_https://github.com/marcglasberg_<br>
_https://twitter.com/glasbergmarcelo_<br>
_https://stackoverflow.com/users/3411681/marcg_<br>
_https://medium.com/@marcglasberg_<br>




