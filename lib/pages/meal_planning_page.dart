import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../shared/utils.dart';

final kToday = DateTime(2023, 6, 1);
final kFirstDay = DateTime(kToday.year, kToday.month - 2, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 2, kToday.day);

final meals = LinkedHashMap<DateTime, Meal>(
  equals: isSameDay,
  hashCode: (DateTime key) => key.day * 1000000 + key.month * 10000 + key.year,
)..addAll(mealsSource);

final mealsSource = {
  for (var day in List.generate(6, (index) => index))
    DateTime.utc(kToday.year, kToday.month, kToday.day - day): Meal('Meal $day')
};

class MealPlanningPage extends StatefulWidget {
  const MealPlanningPage({super.key});

  @override
  MealPlanningPageState createState() => MealPlanningPageState();
}

class MealPlanningPageState extends State<MealPlanningPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  ValueNotifier<Meal?> _selectedMeal = ValueNotifier(null);
  DateTime _focusedDay = kToday;
  DateTime? _selectedDay;

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
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text('${value?.title}'));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
