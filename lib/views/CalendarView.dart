import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {
    const CalendarView({Key? key}) : super(key: key);

    @override
    State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Calendar'),
            ),
            body: const Center(child: Text('Welcome to the Calendar tab')),
        );
    }
}