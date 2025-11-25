import 'package:flutter/material.dart';
import 'package:zen_app/data/entries.dart';
import 'EntryEditorView.dart';
class EntryDetailView extends StatefulWidget {
  final Map<String, dynamic> entry;

  const EntryDetailView({super.key, required this.entry});

  @override
  State<EntryDetailView> createState() => _EntryDetailViewState();
}

class _EntryDetailViewState extends State<EntryDetailView> {
  bool isEditing = false;

  late TextEditingController promptController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    promptController = TextEditingController(text: widget.entry["prompt"]);
    contentController = TextEditingController(text: widget.entry["content"]);
  }

  Future<void> saveChanges() async {
    final repo = EntryRepository();
    final id = widget.entry["id"];

    final updated = {
      "prompt": promptController.text,
      "content": contentController.text,
      "timestamp": widget.entry["timestamp"],
    };

    await repo.updateEntry(id, updated);

    setState(() {
      widget.entry["prompt"] = updated["prompt"];
      widget.entry["content"] = updated["content"];
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = widget.entry["timestamp"];
    print(widget.entry);
    return Scaffold(
      appBar: AppBar(
        title: Text(timestamp),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                final id = widget.entry["id"];        
                final prompt = widget.entry["prompt"]; 
                final content = widget.entry["content"]; 
                final timestamp = widget.entry["timestamp"];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EntryEditorView(
                      isEditing: true,
                      entryId: id,
                      date: timestamp,
                      prompt: prompt,
                      content: content,
                    ),
                  ),
                );
              },
            ),

          if (isEditing)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: saveChanges,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isEditing
            ? Column(
                children: [
                  TextField(
                    controller: promptController,
                    decoration: const InputDecoration(
                      labelText: "Prompt",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: contentController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        labelText: "Content",
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.entry["prompt"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.entry["content"],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
