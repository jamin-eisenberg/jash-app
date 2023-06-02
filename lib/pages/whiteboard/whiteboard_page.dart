import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:jash/pages/whiteboard/whiteboard_message_info_page.dart';
import 'package:jash/pages/whiteboard/whiteboard_message.dart';
import 'package:jash/widgets/widgets.dart';

class WhiteboardPage extends StatefulWidget {
  const WhiteboardPage(
      {super.key,
      required this.addMessage,
      required this.messages,
      required this.reorderMessages,
      required this.editMessage,
      required this.deleteMessage});

  final FutureOr<void> Function(String message) addMessage;
  final FutureOr<void> Function(List<WhiteboardMessage> message)
      reorderMessages;
  final FutureOr<void> Function(WhiteboardMessage message) editMessage;
  final FutureOr<void> Function(WhiteboardMessage message) deleteMessage;
  final List<WhiteboardMessage> messages;

  @override
  State<WhiteboardPage> createState() => _WhiteboardPageState();
}

class _WhiteboardPageState extends State<WhiteboardPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_WhiteboardState');
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
                        hintText: 'Write on the whiteboard...',
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

                  WhiteboardMessage item = widget.messages.removeAt(oldIndex);
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
                          builder: (_) => WhiteboardMesssageInfoPage(
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
