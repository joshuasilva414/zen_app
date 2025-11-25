import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zen_app/data/entries.dart';
import 'EntryDetailView.dart';
import 'EntryEditorView.dart';
import 'package:zen_app/prompts.dart';
class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  LinkedHashMap<DateTime, List<String>> _entryEvents =
      LinkedHashMap<DateTime, List<String>>(
    equals: isSameDay,
    hashCode: (key) =>
        key.day * 1000000 + key.month * 10000 + key.year,
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final repo = EntryRepository();

    final empty = await repo.isEmpty();
    if (empty) {
      await repo.seedDummyEntries();
    }

    await _loadEntryIndicators();
  }

  Future<void> _loadEntryIndicators() async {
    final repo = EntryRepository();
    final dates = await repo.getAllEntryDates();

    final mapped = <DateTime, List<String>>{};

    for (final d in dates) {
      final parsed = DateTime.parse(d);
      final normalized = DateTime(parsed.year, parsed.month, parsed.day);
      mapped[normalized] = ["entry"];
    }

    setState(() {
      _entryEvents = LinkedHashMap<DateTime, List<String>>(
        equals: isSameDay,
        hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
      )..addAll(mapped);
    });
  }

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

        onDaySelected: (selectedDay, focusedDay) async {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          final repo = EntryRepository();

          final dateKey =
              "${selectedDay.year.toString().padLeft(4, '0')}"
              "-${selectedDay.month.toString().padLeft(2, '0')}"
              "-${selectedDay.day.toString().padLeft(2, '0')}";

          final today = DateTime.now();
          final normalizedToday =
              DateTime(today.year, today.month, today.day);
          final normalizedSelected =
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

          if (normalizedSelected.isAfter(normalizedToday)) {
            return;
          }

          final entry = await repo.getEntryByDate(dateKey);

            if(entry == null){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EntryEditorView(
                      isEditing: false,       // creating new entry
                      entryId: null,          // no ID yet
                      date: dateKey,          // the date user tapped
                      prompt: "",
                      content: "",            // start with empty content
                    ),
                  ),
              );
            }
            else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EntryDetailView(entry: entry),
              ),
            );
          }
          
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
