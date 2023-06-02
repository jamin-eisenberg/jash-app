import 'package:flutter/material.dart';

/// Example event class.
class Meal {
  final String title;

  const Meal(this.title);

  @override
  String toString() => title;
}

/*
 * Utilites for painting icons to canvas
 */
class IconPainter extends BoxPainter {
  final IconData _iconToPaint;
  IconPainter(IconData icon) : _iconToPaint = icon;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    TextPainter tPainter = TextPainter(textDirection: TextDirection.ltr);
    tPainter.text = TextSpan(
        text: String.fromCharCode(_iconToPaint.codePoint),
        style: TextStyle(
            color: Colors.green,
            fontFamily: _iconToPaint.fontFamily,
            package: _iconToPaint.fontPackage));
    tPainter.layout();
    tPainter.paint(canvas, offset.translate(-2.5, -10.0));
  }
}

class IconDecoration extends Decoration {
  final IconData _iconToPaint;
  const IconDecoration(IconData icon) : _iconToPaint = icon;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return IconPainter(_iconToPaint);
  }
}

