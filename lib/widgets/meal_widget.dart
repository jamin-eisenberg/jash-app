import 'package:flutter/material.dart';
import 'package:jash/shared/utils.dart';

class MealWidget extends StatelessWidget {
  final Meal _meal;

  const MealWidget(this._meal, {super.key});

  @override
  Widget build(BuildContext context) {
    var ingredients = _meal.ingredients.entries.toList();
    return Column(
      children: [
        Text(_meal.title),
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: ingredients.length,
                itemBuilder: (context, index) => Container(
                    child: Text(
                        '${ingredients[index].key} - ${ingredients[index].value}'))))
      ],
    );
  }
}
