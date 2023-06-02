import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jash/pages/whiteboard/whiteboard_message.dart';

class WhiteboardMesssageInfoPage extends StatefulWidget {
  const WhiteboardMesssageInfoPage(
      {super.key,
      required this.message,
      required this.editMessage,
      required this.deleteMessage});

  final WhiteboardMessage message;
  final FutureOr<void> Function(WhiteboardMessage message) editMessage;
  final FutureOr<void> Function(WhiteboardMessage message) deleteMessage;

  @override
  State<WhiteboardMesssageInfoPage> createState() =>
      _WhiteboardMesssageInfoPageState();
}

class _WhiteboardMesssageInfoPageState
    extends State<WhiteboardMesssageInfoPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_WhiteboardState');
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Message text: '),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                  ),
                ),
              ],
            ),
          ),
          Text(
              'Created by: ${widget.message.username} (user ID: ${widget.message.userId})'),
          Text('Created on: ${DateFormat().format(widget.message.timePosted)}'),
          Row(
            children: [
              ValueListenableBuilder(
                builder: (context, value, _) {
                  return OutlinedButton(
                    onPressed: widget.message.text == value.text
                        ? null
                        : () {
                            widget.editMessage(WhiteboardMessage(
                                timePosted: widget.message.timePosted,
                                username: widget.message.username,
                                userId: widget.message.userId,
                                dbId: widget.message.dbId,
                                text: value.text));
                            Navigator.pop(context);
                          },
                    child: const Row(
                      children: [
                        Icon(Icons.save),
                        Text('Save'),
                      ],
                    ),
                  );
                },
                valueListenable: _controller,
              ),
              OutlinedButton(
                  style: ButtonStyle(
                      iconColor:
                          MaterialStateProperty.resolveWith((_) => Colors.red),
                      foregroundColor:
                          MaterialStateProperty.resolveWith((_) => Colors.red)),
                  onPressed: () {
                    widget.deleteMessage(widget.message);
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.delete_forever),
                      Text('Delete'),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
