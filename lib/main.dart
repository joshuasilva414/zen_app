import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zen Tabs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Zen Tabs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Welcome to the Home tab')),
            Center(child: Text('Discover content on the Explore tab')),
            Center(child: Text('Manage your profile here')),
          ],
        ),
        bottomNavigationBar: const TabBar(
          indicatorWeight: 5,
          tabs: [
            Tab(icon: Icon(Icons.today), text: 'Today'),
            Tab(icon: Icon(Icons.create), text: 'Create'),
            Tab(icon: Icon(Icons.calendar_view_month), text: 'Calendar'),
          ],
        ),
      ),
    );
  }
}
