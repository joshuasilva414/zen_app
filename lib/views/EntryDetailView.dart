import 'package:flutter/material.dart';
import 'package:zen_app/data/entries.dart';
import 'EntryEditorView.dart';

class EntryDetailView extends StatefulWidget {
  final Map<String, dynamic> entry;
  final List<Map<String, dynamic>>? allEntries;

  const EntryDetailView({super.key, required this.entry, this.allEntries});

  @override
  State<EntryDetailView> createState() => _EntryDetailViewState();
}

class _EntryDetailViewState extends State<EntryDetailView> {
  bool isEditing = false;

  late TextEditingController promptController;
  late TextEditingController contentController;
  late Map<String, dynamic> currentEntry;

  static const months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  void initState() {
    super.initState();
    currentEntry = Map<String, dynamic>.from(widget.entry);
    promptController = TextEditingController(text: currentEntry["prompt"]);
    contentController = TextEditingController(text: currentEntry["content"]);
  }

  Future<void> saveChanges() async {
    final repo = EntryRepository();
    final id = currentEntry["id"];

    final updated = {
      "prompt": promptController.text,
      "content": contentController.text,
      "timestamp": currentEntry["timestamp"],
    };

    await repo.updateEntry(id, updated);

    setState(() {
      currentEntry["prompt"] = updated["prompt"];
      currentEntry["content"] = updated["content"];
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final raw = currentEntry["timestamp"];
    final dt = DateTime.parse(raw);
    final formatted = "${months[dt.month - 1]} ${dt.day}, ${dt.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text(formatted),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                final id = currentEntry["id"];
                final prompt = currentEntry["prompt"];
                final content = currentEntry["content"];
                final timestamp = currentEntry["timestamp"];
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
                ).then((didSave) async {
                  if (didSave == true) {
                    final repo = EntryRepository();
                    final freshEntry = await repo.getEntryByDate(timestamp);
                    if (freshEntry != null && mounted) {
                      setState(() {
                        currentEntry = Map<String, dynamic>.from(freshEntry);
                        promptController.text = freshEntry["prompt"];
                        contentController.text = freshEntry["content"];
                      });
                    }
                  }
                });
              },
            ),

          if (isEditing)
            IconButton(icon: const Icon(Icons.check), onPressed: saveChanges),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isEditing
            ? Column(
                children: [
                  TextField(
                    controller: promptController,
                    decoration: const InputDecoration(labelText: "Prompt"),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: contentController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(labelText: "Content"),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentEntry["prompt"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        currentEntry["content"],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  if (widget.allEntries != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "Today's Entries",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: ListView(
                        children: widget.allEntries!
                            .where((e) {
                              final todayKey = DateTime.now()
                                  .toString()
                                  .substring(0, 10);
                              return e["timestamp"].startsWith(todayKey);
                            })
                            .map((e) {
                              final datetime = DateTime.parse(e["timestamp"]);
                              final time =
                                  "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    time,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFC96442),
                                    ),
                                  ),
                                  subtitle: Text(
                                    e["prompt"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFFC96442),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      currentEntry = Map<String, dynamic>.from(
                                        e,
                                      );
                                      promptController.text = e["prompt"];
                                      contentController.text = e["content"];
                                    });
                                  },
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
