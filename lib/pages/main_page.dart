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
        Consumer<ApplicationState>(builder: (context, appState, _) {
          if (appState.loggedIn) {
            return WhiteboardPage(
              addMessage: (m) => appState.addWhiteboardMessage(m),
              messages: appState.whiteboardMessages,
            );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('You must be signed in to use this feature.'),
                )
              ],
            );
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