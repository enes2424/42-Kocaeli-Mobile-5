import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/diary_operations.dart';
import '../utils/diary_operations.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Future<List<Map<String, dynamic>>> _fetchDiaryEntries;
  List<Map<String, dynamic>>? _diaryEntries;

  @override
  void initState() {
    super.initState();
    _fetchDiaryEntries = database.getDiaryEntries();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 142;
    final width = MediaQuery.of(context).size.width - 32;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            database.supabase.auth.currentUser?.userMetadata?['full_name'] ??
                'Diary',
            style: TextStyle(
              fontFamily: 'Cursive',
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color.fromARGB(255, 59, 42, 35),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                () => ref
                    .read(database.authenticationProvider.notifier)
                    .signOut(context),
          ),
        ],
      ),
      body:
          height <= 0 || width <= 0
              ? null
              : ListView(
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

                          List<int> counts = List.filled(6, 0);

                          for (var entry in _diaryEntries!) {
                            counts[entry['icon_index']]++;
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
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
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
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 4 * height / 54,
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "Your feel for your ${_diaryEntries!.length} entries",
                                            style: TextStyle(
                                              fontSize: height / 30,
                                              fontFamily: 'Cursive',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    for (int i = 0; i < 6; i++)
                                      Container(
                                        color: icons[i]['color'].withAlpha(100),
                                        height: height / 18,
                                        width: width + 16,
                                        child: Row(
                                          children: [
                                            Expanded(child: SizedBox()),
                                            Expanded(
                                              child: Center(
                                                child: Icon(
                                                  icons[i]['icon'],
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${(counts[i] / _diaryEntries!.length * 100).round()}%",
                                                  style: TextStyle(
                                                    fontSize: height / 40,
                                                    fontFamily: 'Cursive',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(child: SizedBox()),
                                          ],
                                        ),
                                      ),
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
