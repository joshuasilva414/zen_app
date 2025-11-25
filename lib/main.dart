import 'package:flutter/material.dart';
import 'views/HomeView.dart';
import 'views/EntryView.dart';
import 'views/CalendarView.dart';
import 'db.dart';
import 'package:zen_app/theme/claude_theme.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseInstance.instance.db;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zen Tabs',
      theme: claudeLightTheme,
      darkTheme: claudeDarkTheme,
      themeMode: ThemeMode.system,
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
        body: TabBarView(
          children: [
            HomeView(),
            EntryView(),
            Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (_) => CalendarView(),
                );
              },
            ),
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
