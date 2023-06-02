import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:jash/pages/notepad/notepad_message_info_page.dart';
import 'package:jash/pages/notepad/notepad_message.dart';
import 'package:jash/widgets/widgets.dart';

class NotepadPage extends StatefulWidget {
  const NotepadPage(
      {super.key,
      required this.addMessage,
      required this.messages,
      required this.reorderMessages,
      required this.editMessage,
      required this.deleteMessage});

  final FutureOr<void> Function(String message) addMessage;
  final FutureOr<void> Function(List<NotepadMessage> message)
      reorderMessages;
  final FutureOr<void> Function(NotepadMessage message) editMessage;
  final FutureOr<void> Function(NotepadMessage message) deleteMessage;
  final List<NotepadMessage> messages;

  @override
  State<NotepadPage> createState() => _NotepadPageState();
}

class _NotepadPageState extends State<NotepadPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_NotepadPageState');
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Prevent default event handler
    document.onContextMenu.listen((event) => event.preventDefault());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Write on the notepad...',
                      ),
                    ),
                  ),
                  StyledButton(
                    onPressed: () async {
                      var text = _controller.text;
                      _controller.clear();
                      await widget.addMessage(text);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 4),
                        Text('Add'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }

                  NotepadMessage item = widget.messages.removeAt(oldIndex);
                  widget.messages.insert(newIndex, item);
                  widget.reorderMessages(widget.messages);
                });
              },
              children: [
                for (var e in widget.messages)
                  GestureDetector(
                    key: Key(e.dbId),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotepadMessageInfoPage(
                            message: e,
                            editMessage: widget.editMessage,
                            deleteMessage: widget.deleteMessage,
                          ),
                        ),
                      );
                    },
                    child: ListTile(title: Text(e.text)),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
