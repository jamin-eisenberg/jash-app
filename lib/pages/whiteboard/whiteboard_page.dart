import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jash/widgets/widgets.dart';

class WhiteboardPage extends StatefulWidget {
  const WhiteboardPage({super.key, required this.addMessage, required this.messages});

  final FutureOr<void> Function(String message) addMessage;
  final List<String> messages;

  @override
  State<WhiteboardPage> createState() => _WhiteboardPageState();
}

class _WhiteboardPageState extends State<WhiteboardPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_WhiteboardState');
  final _controller = TextEditingController();

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
                        await widget.addMessage(_controller.text);
                      _controller.clear();
                    },
                    child: Row(
                      children: const [
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
          // for (var e in widget.messages) Paragraph("${e.name}: ${e.message}"),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
