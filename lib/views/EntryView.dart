import 'package:flutter/material.dart';

class EntryView extends StatefulWidget {
    const EntryView({Key? key, this.prompt}) : super(key: key);

    final String? prompt;

    @override
    State<EntryView> createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Entry'),
            ),
            body: Center(child: Text(widget.prompt ?? 'Welcome to the Entry tab')),
        );
    }
}