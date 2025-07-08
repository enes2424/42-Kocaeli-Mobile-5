import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/diary_operations.dart';
import '../utils/diary_operations.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends ConsumerState<AgendaPage> {
  late Future<List<Map<String, dynamic>>> _fetchDiaryEntries;
  List<Map<String, dynamic>>? _diaryEntries;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now().toLocal();

  @override
  void initState() {
    super.initState();
    _fetchDiaryEntries = database.getDiaryEntries();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 58;
    final width = MediaQuery.of(context).size.width - 32;

    double calendarHeight = getCalendarHeight(_calendarFormat);
    calendarHeight = calendarHeight > height ? height : calendarHeight;

    return Scaffold(
      body:
          height <= 0 || width <= 0
              ? null
              : Column(
                children: [
                  SizedBox(
                    height: height,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchDiaryEntries,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${snapshot.error}',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          _diaryEntries = snapshot.data;
                          if (_diaryEntries!.isEmpty) {
                            return Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "No diary entries found.",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: [
                              Container(
                                color: Colors.amber.withAlpha(100),
                                height: calendarHeight,
                                child: SingleChildScrollView(
                                  child: TableCalendar(
                                    firstDay: DateTime.utc(2010, 10, 16),
                                    lastDay: DateTime.utc(2030, 3, 14),
                                    focusedDay: _focusedDay,
                                    calendarFormat: _calendarFormat,
                                    selectedDayPredicate: (day) {
                                      return isSameDay(_focusedDay, day);
                                    },
                                    onFormatChanged: (format) {
                                      setState(() {
                                        _calendarFormat = format;
                                      });
                                    },
                                    onDaySelected: (selectedDay, focusedDay) {
                                      setState(() {
                                        _focusedDay = focusedDay;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height - calendarHeight,
                                child: ListView(
                                  padding: const EdgeInsets.all(16.0),
                                  children: [
                                    for (
                                      int i = 0;
                                      i < _diaryEntries!.length;
                                      i++
                                    )
                                      diaryEntryCard(
                                            context,
                                            _diaryEntries![i],
                                            width: width / 5,
                                            setState:
                                                () => setState(() {
                                                  _fetchDiaryEntries =
                                                      database
                                                          .getDiaryEntries();
                                                }),
                                            selectedDay: _focusedDay,
                                          ) ??
                                          const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return Column();
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  double getCalendarHeight(CalendarFormat format) {
    switch (format) {
      case CalendarFormat.month:
        return 340;
      case CalendarFormat.twoWeeks:
        return 184;
      case CalendarFormat.week:
        return 132;
    }
  }
}
