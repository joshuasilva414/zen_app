import 'package:flutter/material.dart';

import 'EntryEditorView.dart';

class EntryView extends StatefulWidget {
  const EntryView({super.key});

  @override
  State<EntryView> createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {
  String dateKey = "";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateKey =
        "${now.year.toString().padLeft(4, '0')}"
        "-${now.month.toString().padLeft(2, '0')}"
        "-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return EntryEditorView(
      date: dateKey,
      isEditing: false,
      entryId: null,
      prompt: "",
      content: "",
    );
  }
}
