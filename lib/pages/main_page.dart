import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jash/app_state.dart';
import 'package:jash/pages/notepad/notepad_page.dart';
import 'package:provider/provider.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      if (!appState.loggedIn) {
        context.push('/sign-in');
        return Container();
      } else {
        return ScrollNavigation(
          items: const [
            ScrollNavigationItem(
              title: 'Notepad',
              icon: Icon(Icons.edit_note),
            ),
            ScrollNavigationItem(
              title: 'Profile',
              icon: Icon(Icons.account_circle),
            ),
          ],
          pages: [
            NotepadPage(
              addMessage: (m) => appState.addNotepadMessage(m),
              reorderMessages: (ms) => appState.updateNotepadMessagesOrder(ms),
              deleteMessage: (m) => appState.deleteNotepadMessage(m),
              editMessage: (m) => appState.updateNotepadMessage(m),
              messages: appState.notepadMessages,
            ),
            ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            ),
          ],
          physics: true,
          identiferStyle: const NavigationIdentiferStyle(
              position: IdentifierPosition.topAndRight),
        );
      }
    });
  }
}
