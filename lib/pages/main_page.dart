import 'package:flutter/material.dart';
import 'package:jash/pages/home_page.dart';
import 'package:jash/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedIndex = 0;

  Widget _selectedPage() {
    switch (selectedIndex) {
      case 0:
        return HomePage();
      case 1:
        return ProfilePage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page = _selectedPage();

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: page,
              ),
            ),
            SafeArea(
              child: BottomNavigationBar(
                // extended: constraints.maxWidth >= 600,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Profile',
                  ),
                ],
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
