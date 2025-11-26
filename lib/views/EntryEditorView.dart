import 'package:flutter/material.dart';
import 'package:zen_app/data/entries.dart';
import 'package:zen_app/prompts.dart';

class EntryEditorView extends StatefulWidget {
  final bool isEditing;
  final int? entryId;
  final String date;
  final String prompt;
  final String? content;

  const EntryEditorView({
    super.key,
    required this.date,
    required this.prompt,
    this.content,
    this.isEditing = false,
    this.entryId,
  });

  @override
  State<EntryEditorView> createState() => _EntryEditorViewState();
}

class _EntryEditorViewState extends State<EntryEditorView> {
  late TextEditingController contentController;
  String? selectedPrompt;

  @override
  void initState() {
    super.initState();

    selectedPrompt =
        (widget.prompt.isEmpty || !allPrompts.contains(widget.prompt))
            ? null
            : widget.prompt;

    contentController = TextEditingController(text: widget.content ?? "");
  }

  Future<void> save() async {
    final repo = EntryRepository();

    if (widget.isEditing && widget.entryId != null) {
      await repo.updateEntry(
        widget.entryId!,
        {
          "prompt": selectedPrompt ?? "",
          "timestamp": widget.date,
          "content": contentController.text,
        },
      );
    } else {
      await repo.insertEntry(
        selectedPrompt ?? "",
        widget.date,
        contentController.text,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? "Edit Entry" : "New Entry"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedPrompt,
              hint: const Text("Select a prompt"),
              isExpanded: true,
              items: allPrompts.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPrompt = value;
                });
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write your entry...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
