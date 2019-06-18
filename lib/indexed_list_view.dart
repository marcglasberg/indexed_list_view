library indexed_list_view;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IndexedListView extends StatefulWidget {
  //
  const IndexedListView.builder({
    Key key,
    this.itemBuilder,
    this.controller,
  }) : super(key: key);

  final IndexedScrollController controller;
  final IndexedWidgetBuilder itemBuilder;

  @override
  _IndexedListViewState createState() => _IndexedListViewState();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _UnboundedScrollPosition extends ScrollPositionWithSingleContext {
  _UnboundedScrollPosition({
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition oldPosition,
    double initialPixels,
  }) : super(
          physics: physics,
          context: context,
          oldPosition: oldPosition,
          initialPixels: initialPixels,
        );

  @override
  double get minScrollExtent => double.negativeInfinity;

  @override
  double get maxScrollExtent => double.infinity;

  /// There is a feedback-loop between aboveController and belowController. When one of them is
  /// being used, it controls the other. However if they get out of sync, for timing reasons,
  /// the controlled one with try to control the other, and the jump will stop the real controller.
  /// For this reason, we can't let one stop the other (idle and ballistics) in this situation.
  void jumpToWithoutGoingIdleAndKeepingBallistic(double value) {
    if (pixels != value) {
      forcePixels(value);
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class IndexedScrollController extends ScrollController {
  //
  int _startIndex = 0;
  int get startIndex => _startIndex;

  bool _hasChangedStartIndex = false;

  IndexedScrollController({
    double initialScrollOffset = 0.0,
    keepScrollOffset = true,
    debugLabel,
  }) : super(
            initialScrollOffset: initialScrollOffset,
            keepScrollOffset: keepScrollOffset,
            debugLabel: debugLabel);

  void jumpToIndex(int index) {
    if (_startIndex != index) {
      _startIndex = index;
      _hasChangedStartIndex = true;
      notifyListeners();
    } else
      jumpTo(0.0);
  }

  /// Animates only if you are going back to the last index you jumped to.
  void animateToIndex(
    int index, {
    Duration duration = const Duration(milliseconds: 750),
    Curve curve = Curves.decelerate,
  }) {
    if (_startIndex != index) {
      _startIndex = index;
      _hasChangedStartIndex = true;
      notifyListeners();
    } else
      animateTo(0.0, duration: duration, curve: curve);
  }

  @override
  _UnboundedScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition oldPosition,
  ) {
    return _UnboundedScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      initialPixels: initialScrollOffset,
    );
  }

  void _jumpToWithoutGoingIdleAndKeepingBallistic(double value) {
    assert(positions.isNotEmpty, 'ScrollController not attached.');
    for (_UnboundedScrollPosition position in new List<ScrollPosition>.from(positions))
      position.jumpToWithoutGoingIdleAndKeepingBallistic(value);
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _IndexedListViewState extends State<IndexedListView> {
  //
  IndexedScrollController _positiveController;
  IndexedScrollController _negativeController;

  int startIndex = 0;

  @override
  void initState() {
    super.initState();

    // Use the widget.controller as the positive controller, if given.
    // Otherwise, create our own internal positive controller.
    if (widget.controller == null) {
      _positiveController = IndexedScrollController();
    } else
      _positiveController = widget.controller;

    // Create an internal negative controller.
    _negativeController = IndexedScrollController(
      keepScrollOffset: false,
      initialScrollOffset: -10000.0, // Starts out of the screen.
    );

    // Instantiate the negative and positive list positions, relative to one another.
    WidgetsBinding.instance.addPostFrameCallback((_) => _negativeController
        .jumpTo(-_negativeController.position.extentInside - _positiveController.position.pixels));

    // Add both controller listeners.
    _addPositiveControllerListener();
    _addNegativeControllerListener();
  }

  void _addPositiveControllerListener() {
    _positiveController.addListener(() {
      // If the start index has changed, move both controllers to the initial position.
      if (_positiveController._hasChangedStartIndex) {
        _positiveController._hasChangedStartIndex = false;
        startIndex = _positiveController._startIndex;

        // Recreate the _negativeController.
        _negativeController?.dispose();
        _negativeController = IndexedScrollController(
            keepScrollOffset: false,
            initialScrollOffset: -_negativeController.position.extentInside);
        _addNegativeControllerListener();

        setState(() {});
      }

      // The POSITIVE list moves the NEGATIVE list, but only if the NEGATIVE list position would change.
      else {
        if (_negativeController.hasClients) {
          var newNegativePosition =
              -_negativeController.position.extentInside - _positiveController.position.pixels;
          var oldNegativePosition = _negativeController.position.pixels;

          if (newNegativePosition != oldNegativePosition) {
            _negativeController._jumpToWithoutGoingIdleAndKeepingBallistic(newNegativePosition);
          }
        }
      }
    });
  }

  void _addNegativeControllerListener() {
    // The NEGATIVE list moves the POSITIVE list, but only if the POSITIVE list position would change.
    _negativeController.addListener(() {
      var newBelowPosition =
          -_positiveController.position.extentInside - _negativeController.position.pixels;
      var oldBelowPosition = _positiveController.position.pixels;

      if (newBelowPosition != oldBelowPosition) {
        _positiveController._jumpToWithoutGoingIdleAndKeepingBallistic(newBelowPosition);
      }
    });
  }

  @override
  void didUpdateWidget(IndexedListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TODO: Should check if widget.controller changed, and remove/addListener as needed.
  }

  @override
  void dispose() {
    if (widget.controller == null) _positiveController.dispose();

    _negativeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //

    var negativeList = ListView.builder(
        key: ObjectKey("neg$startIndex"),
        controller: _negativeController,
        physics: const AlwaysScrollableScrollPhysics(),
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          var relativeIndex = -index - 1 + startIndex;
          return widget.itemBuilder(context, relativeIndex);
        });

    var positiveList = ListView.builder(
      key: ObjectKey("pos$startIndex"),
      controller: _positiveController,
      itemBuilder: (BuildContext context, int index) {
        var relativeIndex = index + startIndex;
        return widget.itemBuilder(context, relativeIndex);
      },
    );

    return Stack(
      children: <Widget>[
        negativeList,
        _ControlledIgnorePointer(
          child: positiveList,
          controller: _positiveController,
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _ControlledIgnorePointer extends SingleChildRenderObjectWidget {
  //
  final ScrollController controller;

  const _ControlledIgnorePointer({@required this.controller, @required Widget child})
      : assert(controller != null),
        assert(child != null),
        super(child: child);

  @override
  _ControlledRenderIgnorePointer createRenderObject(BuildContext context) {
    return new _ControlledRenderIgnorePointer(controller: controller);
  }

  @override
  void updateRenderObject(BuildContext context, _ControlledRenderIgnorePointer renderObject) {
    renderObject..controller = controller;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

/// Render object that is invisible to hit testing in certain controller offsets.
class _ControlledRenderIgnorePointer extends RenderProxyBox {
  _ControlledRenderIgnorePointer({RenderBox child, ScrollController controller})
      : _controller = controller,
        super(child) {
    assert(_controller != null);
  }

  ScrollController get controller => _controller;
  ScrollController _controller;
  set controller(ScrollController value) {
    assert(value != null);
    if (value == _controller) return;
    _controller = value;
  }

  @override
  bool hitTest(HitTestResult hitTestResult, {Offset position}) {
    bool ignore = -controller.position.pixels > position.dy;
    var boolResult = ignore ? false : super.hitTest(hitTestResult, position: position);
    return boolResult;
  }
}
