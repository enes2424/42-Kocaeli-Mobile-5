import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchDiaryEntries = database.getDiaryEntries();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 58;
    final width = MediaQuery.of(context).size.width - 32;
    return Scaffold(
      body:
          height <= 0 || width <= 0
              ? null
              : Column(
                children: [
                  SizedBox(
                    height: 5 * height / 6,
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
                                color: Colors.black.withAlpha(100),
                                width: width + 16,
                                height: 22 * height / 54,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 4 * height / 54,
                                      child: Center(
                                        child: Text(
                                          "Your last diary entries",
                                          style: TextStyle(
                                            fontSize: height / 30,
                                            fontFamily: 'Cursive',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 3,
                                      child: ListView(
                                        padding: const EdgeInsets.all(16.0),
                                        children: [
                                          for (
                                            int i = 0;
                                            i < _diaryEntries!.length && i < 2;
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
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height / 54),
                              Container(
                                color: Colors.black.withAlpha(100),
                                width: width + 16,
                                height: 22 * height / 54,
                              ),
                            ],
                          );
                        }
                        return Column();
                      },
                    ),
                  ),
                  SizedBox(
                    height: height / 6,
                    child: Center(
                      child: SizedBox(
                        height: height / 15,
                        width: width / 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool success = await addDiaryEntry(context);
                            if (success) {
                              setState(() {
                                _fetchDiaryEntries = database.getDiaryEntries();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              187,
                              65,
                              21,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(height / 60),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'New diary entry',
                              style: TextStyle(
                                fontSize: height / 40,
                                fontFamily: 'Cursive',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
