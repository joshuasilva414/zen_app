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

// Provides theme mode + toggle function to entire app
class ThemeController extends InheritedWidget {
  final ThemeMode mode;
  final VoidCallback toggle;

  const ThemeController({
    super.key,
    required this.mode,
    required this.toggle,
    required super.child,
  });

  static ThemeController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeController>()!;
  }

  @override
  bool updateShouldNotify(ThemeController oldWidget) {
    return oldWidget.mode != mode;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      mode: mode,
      toggle: toggleTheme,
      child: MaterialApp(
        title: 'Common Zense',
        theme: claudeLightTheme,
        darkTheme: claudeDarkTheme,
        themeMode: mode,
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Common Zense'),
      ),
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
    final controller = ThemeController.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(
                controller.mode == ThemeMode.dark
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
              ),
              onPressed: controller.toggle,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            HomeView(),
            EntryView(),
            Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(builder: (_) => CalendarView());
              },
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          indicatorWeight: 5,
          tabs: [
            Tab(
              icon: Image.asset('lib/icons/today.png', width: 50, height: 50),
              text: 'Today',
            ),
            Tab(
              icon: Image.asset('lib/icons/create.png', width: 50, height: 50),
              text: 'Create',
            ),
            Tab(
              icon: Image.asset(
                'lib/icons/calendar.png',
                width: 50,
                height: 50,
              ),
              text: 'Calendar',
            ),
          ],
        ),
      ),
    );
  }
}
