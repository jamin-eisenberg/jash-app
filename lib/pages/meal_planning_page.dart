import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jash/widgets/meal_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../shared/utils.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 2, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 2, kToday.day);

final meals = LinkedHashMap<DateTime, Meal>(
  equals: isSameDay,
  hashCode: (DateTime key) => key.day * 1000000 + key.month * 10000 + key.year,
)..addAll(mealsSource);

final mealsSource = {
  for (var day in List.generate(6, (index) => index))
    DateTime.utc(kToday.year, kToday.month, kToday.day - day): Meal(
        'Meal $day', {const Ingredient('chicken'): Quantity(5, Unit.ounce)})
};

class MealPlanningPage extends StatefulWidget {
  const MealPlanningPage({super.key});

  @override
  MealPlanningPageState createState() => MealPlanningPageState();
}

class MealPlanningPageState extends State<MealPlanningPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  ValueNotifier<Meal?> _selectedMeal = ValueNotifier(meals[kToday]);
  DateTime _focusedDay = kToday;
  DateTime _selectedDay = kToday;

  @override
  void dispose() {
    super.dispose();
  }

  List<Meal> _getMealsForDay(DateTime day) {
    // Implementation example
    if (meals[day] != null) {
      return [meals[day]!];
    }
    return [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = selectedDay;
      _selectedDay = selectedDay;
      _selectedMeal = ValueNotifier(meals[_selectedDay]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar<Meal>(
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: const CalendarStyle(
                isTodayHighlighted: true,
                outsideDaysVisible: false,
                markerDecoration: IconDecoration(Icons.check_circle)),
            focusedDay: _focusedDay,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getMealsForDay,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<Meal?>(
              valueListenable: _selectedMeal,
              builder: (context, value, _) {
                if (value != null) {
                  return Column(children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.blue),
                            child: MealWidget(value))),
                    ElevatedButton(
                        onPressed: () => print("Edit"),
                        child: const Text("Change Meal"))
                  ]);
                } else {
                  return ElevatedButton(
                    onPressed: () => setState(() {
                      meals.putIfAbsent(
                          _selectedDay,
                          () => Meal("New Meal", {
                                const Ingredient("Ing"): Quantity(1, Unit.pound)
                              }));
                      setState(() {
                        _selectedMeal = ValueNotifier(meals[_selectedDay]);
                      });
                    }),
                    child: const Text("Add Meal"),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
