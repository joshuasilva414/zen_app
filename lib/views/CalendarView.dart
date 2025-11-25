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
        hashCode: (key) =>
            key.day * 1000000 + key.month * 10000 + key.year,
      )..addAll(mapped);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const SizedBox(height: 16),

          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,

              onPageChanged: (focusedDay) {
                // instant UI update when swiping
                setState(() {
                  _focusedDay = focusedDay;
                });

                // load events in background
                _loadEntryIndicators();
              },

              selectedDayPredicate: (day) =>
                  isSameDay(_selectedDay, day),

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
                    DateTime(selectedDay.year, selectedDay.month,
                        selectedDay.day);

                if (normalizedSelected.isAfter(normalizedToday)) {
                  return;
                }

                final entry = await repo.getEntryByDate(dateKey);

                if (entry == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EntryEditorView(
                        isEditing: false,
                        entryId: null,
                        date: dateKey,
                        prompt: "",
                        content: "",
                      ),
                    ),
                  ).then((didSave) {
                    if (didSave == true) {
                      setState(() {});    // instant refresh
                      _loadEntryIndicators(); // async refresh
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EntryDetailView(entry: entry),
                    ),
                  ).then((didSave) {
                    if (didSave == true) {
                      setState(() {});    // instant refresh
                      _loadEntryIndicators(); // async refresh
                    }
                  });
                }
              },

              calendarFormat: _calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month'
              },

              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },

              eventLoader: (day) {
                final normalized = DateTime(day.year, day.month, day.day);
                return _entryEvents[normalized] ?? [];
              },

              calendarStyle: const CalendarStyle(
                markersMaxCount: 0,
                markerDecoration: BoxDecoration(),
                 selectedDecoration: BoxDecoration(
                  color: Color(0xFFC96442), // orange
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),

                // Today (outlined orange circle)
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: Color(0xFFC96442), 
                      width: 2,
                    ),
                  ),
                ),
               
              ),

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  final normalized = DateTime(date.year, date.month, date.day);
                  final hasEntry = _entryEvents[normalized] != null;

                  if (hasEntry) {
                    return Center(
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(
                          color: Color(0xFFC96442),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return null;
                },

                markerBuilder: (context, date, events) {
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
