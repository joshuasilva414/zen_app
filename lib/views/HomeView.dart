import 'package:flutter/material.dart';
import 'dart:math';
import 'package:zen_app/db.dart';
import 'package:zen_app/views/EntryEditorView.dart';
import 'package:zen_app/views/EntryDetailView.dart';
import 'package:zen_app/data/entries.dart';
import '../prompts.dart';

class HomeView extends StatefulWidget {
    const HomeView({Key? key}) : super(key: key);

    @override
    State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
    List<String> prompts = [];
    Map<String, dynamic>? todayEntry;

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

    Future<void> loadTodayEntry() async {
        final now = DateTime.now();
        final dateKey = "${now.year.toString().padLeft(4, '0')}"
            "-${now.month.toString().padLeft(2, '0')}"
            "-${now.day.toString().padLeft(2, '0')}";
        
        final repo = EntryRepository();
        final entry = await repo.getEntryByDate(dateKey);
        
        setState(() {
            todayEntry = entry;
        });
    }

    @override
    void initState() {
        super.initState();
        loadPrompts();
        loadTodayEntry();
    }
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Home'),
            ),
            body: Column(
                children: [
                    prompts.isEmpty 
                        ? const Center(child: Text('No prompts available')) 
                        : Expanded(
                            child: ListView.builder(
                                itemCount: prompts.length,
                                itemBuilder: (context, index) {
                                    return ListTile(
                                        title: Text(prompts[index]),
                                        onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => EntryEditorView(
                                                        isEditing: false,
                                                        entryId: null,
                                                        date: DateTime.now().toString(),
                                                        prompt: prompts[index],
                                                        content: "",
                                                    ),
                                                ),
                                            ).then((didSave) {
                                                if (didSave == true) {
                                                    loadTodayEntry();
                                                }
                                            });
                                        },
                                    );
                                },
                            ),
                        ),
                    
                    // Display link to today's entry if it exists
                    if (todayEntry != null)
                        Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey.shade300),
                                ),
                            ),
                            child: ListTile(
                                title: Text(
                                    todayEntry!["prompt"] ?? "Today's Entry",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFC96442),
                                    ),
                                ),
                                subtitle: const Text("View today's entry"),
                                trailing: const Icon(Icons.arrow_forward, color: Color(0xFFC96442)),
                                onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EntryDetailView(entry: todayEntry!),
                                        ),
                                    ).then((didSave) {
                                        if (didSave == true) {
                                            setState(() {});
                                            loadTodayEntry();
                                        }
                                    });
                                },
                            ),
                        ),
                ],
            )
        );
    }
}