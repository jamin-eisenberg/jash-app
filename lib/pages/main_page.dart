import 'package:flutter/material.dart';
import 'package:jash/app_state.dart';
import 'package:jash/pages/profile_page.dart';
import 'package:jash/pages/whiteboard/whiteboard_page.dart';
import 'package:provider/provider.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollNavigation(
      items: const [
        ScrollNavigationItem(
          title: 'Whiteboard',
          icon: Icon(Icons.edit_note),
        ),
        ScrollNavigationItem(
          title: 'Profile',
          icon: Icon(Icons.account_circle),
        ),
      ],
      pages: [
        Consumer<ApplicationState>(
            builder: (context, appState, _) {
              if (appState.loggedIn) {
                WhiteboardPage(messages: appState., )
              }
            }),
        const ProfilePage()
      ],
      physics: true,
      identiferStyle: const NavigationIdentiferStyle(
          position: IdentifierPosition.topAndRight),
    );
  }
}

// class _MainPageState extends State<MainPage> {
//   var selectedIndex = 0;
//
//   Widget _selectedPage() {
//     switch (selectedIndex) {
//       case 0:
//         return HomePage();
//       case 1:
//         return ProfilePage();
//       default:
//         throw UnimplementedError('no widget for $selectedIndex');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget page = _selectedPage();
//
//     return LayoutBuilder(builder: (context, constraints) {
//       return Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 child: page,
//               ),
//             ),
//             SafeArea(
//               child: BottomNavigationBar(
//                 // extended: constraints.maxWidth >= 600,
//                 items: const [
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.home),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.account_circle),
//                     label: 'Profile',
//                   ),
//                 ],
//                 currentIndex: selectedIndex,
//                 onTap: (value) {
//                   setState(() {
//                     selectedIndex = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
