import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jash/pages/notepad/notepad_message.dart';

class NotepadMessageInfoPage extends StatefulWidget {
  const NotepadMessageInfoPage(
      {super.key,
      required this.message,
      required this.editMessage,
      required this.deleteMessage});

  final NotepadMessage message;
  final FutureOr<void> Function(NotepadMessage message) editMessage;
  final FutureOr<void> Function(NotepadMessage message) deleteMessage;

  @override
  State<NotepadMessageInfoPage> createState() =>
      _NotepadMessageInfoPageState();
}

class _NotepadMessageInfoPageState
    extends State<NotepadMessageInfoPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_NotepadMessageInfoPageState');
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message Info')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tooltip(
                message: '(User ID: ${widget.message.userId})',
                child: Text('Last edited by: ${widget.message.username}')),
            Text(
                'Last edited on: ${DateFormat().format(widget.message.timePosted)}'),
            Row(
              children: [
                const Text(
                  'Text: ',
                ),
                const SizedBox(
                  width: 8,
                ),
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: TextFormField(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Flexible(
                  child: ValueListenableBuilder(
                    builder: (context, value, _) {
                      return OutlinedButton(
                        onPressed: widget.message.text == value.text
                            ? null
                            : () {
                                widget.editMessage(NotepadMessage(
                                    timePosted: DateTime.now(),
                                    username: FirebaseAuth.instance.currentUser!.displayName ?? "",
                                    userId: FirebaseAuth.instance.currentUser!.uid,
                                    dbId: widget.message.dbId,
                                    text: value.text));
                                Navigator.pop(context);
                              },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            Text('Save'),
                          ],
                        ),
                      );
                    },
                    valueListenable: _controller,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: OutlinedButton(
                      style: ButtonStyle(
                          iconColor: MaterialStateProperty.resolveWith(
                              (_) => Colors.red),
                          foregroundColor: MaterialStateProperty.resolveWith(
                              (_) => Colors.red)),
                      onPressed: () {
                        widget.deleteMessage(widget.message);
                        Navigator.pop(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_forever),
                          Text('Delete'),
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
