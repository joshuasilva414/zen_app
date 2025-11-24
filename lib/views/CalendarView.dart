import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  int _getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  LinkedHashMap<DateTime, List<String>> _entryEvents =
      LinkedHashMap<DateTime, List<String>>(
    equals: isSameDay,
    hashCode: (key) =>
        key.day * 1000000 + key.month * 10000 + key.year, // same as _getHashCode
  );

  @override
  void initState() {
    super.initState();
    //_loadEntryIndicators();
  }

 /*Future<void> _loadEntryIndicators() async {
  final repo = EntryRepository();
  final dates = await repo.getAllEntryDates();

  final mapped = <DateTime, List<String>>{};

  for (final d in dates) {
    final parsed = DateTime.parse(d);
    final normalized = DateTime(parsed.year, parsed.month, parsed.day);
    mapped[normalized] = ["entry"];
  }

  setState(() {
    _entryEvents.addAll(mapped);
  });
}*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,

        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },

        calendarFormat: _calendarFormat,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},

        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },

        eventLoader: (day) {
          return _entryEvents[day] ?? [];
        },

        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return null;

            return Positioned(
              bottom: 4,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7A1A),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
