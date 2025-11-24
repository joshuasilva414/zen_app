import 'package:flutter/material.dart';

class EntryView extends StatefulWidget {
    const EntryView({Key? key}) : super(key: key);

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
            body: const Center(child: Text('Welcome to the Entry tab')),
        );
    }
}