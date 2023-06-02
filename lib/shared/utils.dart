import 'package:flutter/material.dart';

/// Possible standard units.
enum Unit {
  ounce,
  pound,
  package,
}

/// Amount of an ingredient.
class Quantity {
  Unit unit;
  double amount;

  Quantity(this.amount, this.unit);
}

/// Types of things you would put into a meal
class Ingredient {
  final String name;

  const Ingredient(this.name);
}

/// Basic description of a meal, in terms of what's in it.
class Meal {
  final String title;
  final Map<Ingredient, Quantity> ingredients;
  double scale;

  Meal(this.title, this.ingredients, {this.scale = 1});

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
