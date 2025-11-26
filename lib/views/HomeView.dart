import 'package:flutter/material.dart';
import 'dart:math';
import 'package:zen_app/db.dart';
import 'package:zen_app/views/EntryView.dart';
import '../prompts.dart';

class HomeView extends StatefulWidget {
    const HomeView({Key? key}) : super(key: key);

    @override
    State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
    List<String> prompts = [];

    loadPrompts() {
        if (allPrompts.isEmpty) {
            setState(() {
                prompts = [];
            });
            return;
        }

        final now = DateTime.now();
        final seed = now.year * 10000 + now.month * 100 + now.day * 100 + now.hour * 100 + now.minute * 100 + now.second * 100 + now.millisecond;
        final random = Random(seed);

        List<String> shuffledPrompts = List.from(allPrompts);
        shuffledPrompts.shuffle(random);

        setState(() {
            prompts = shuffledPrompts.take(3).toList();
        });
    }

    @override
    void initState() {
        super.initState();
        loadPrompts();
    }
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Home'),
            ),
            body: prompts.isEmpty ? const Center(child: Text('No prompts available')) : ListView.builder(
                itemCount: prompts.length,
                itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(prompts[index]),
                        onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EntryView(prompt: prompts[index]),
                                ),
                            );
                        },
                    );
                },
            ),
        );
    }
}