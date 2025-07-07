import 'package:advanceddiaryapp/src/utils/snackbar.dart';
import '../database/diary_operations.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

final List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

final List<String> weekdays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

final List<Map<String, dynamic>> icons = [
  {"icon": Icons.sentiment_very_satisfied, "color": Colors.blue},
  {"icon": Icons.sentiment_satisfied, "color": Colors.green},
  {"icon": Icons.sentiment_neutral, "color": Colors.yellow},
  {"icon": Icons.sentiment_dissatisfied, "color": Colors.orange},
  {"icon": Icons.sentiment_very_dissatisfied, "color": Colors.red},
  {"icon": Icons.mood_bad, "color": Colors.purple},
];

Future<bool> addDiaryEntry(BuildContext context) async {
  String title = "";
  String text = "";
  int selectedIcon = 1;
  Future<void> Function()? futureAddDiaryEntry;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) {
              IconButton iconButton(int index) => IconButton(
                icon: Icon(
                  icons[index]["icon"],
                  size: 36,
                  color: icons[index]["color"],
                ),
                onPressed: () {
                  setState(() {
                    selectedIcon = index;
                  });
                  Navigator.pop(context);
                },
              );
              return AlertDialog(
                backgroundColor: icons[selectedIcon]["color"].withAlpha(162),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                title: Text(
                  "Add an entry",
                  style: TextStyle(
                    fontFamily: 'Cursive',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(139, 239, 229, 229),
                        hintText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(icons[selectedIcon]["icon"], color: Colors.white),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      for (int i = 0; i < icons.length; i++)
                                        iconButton(i),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(139, 239, 229, 229),
                        hintText: 'Text',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (title.isEmpty || text.isEmpty) {
                        showSnackbar(
                          context,
                          'Title and text cannot be empty!',
                        );
                        return;
                      }
                      futureAddDiaryEntry =
                          () =>
                              database.addDiaryEntry(title, text, selectedIcon);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontFamily: 'Cursive',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
  if (futureAddDiaryEntry != null) {
    try {
      await futureAddDiaryEntry!();
      return true;
    } catch (error) {
      if (context.mounted) {
        showSnackbar(context, 'Failed to add diary entry: $error');
      }
      return false;
    }
  }
  return false;
}

Future<bool> viewDiaryEntry(
  BuildContext context,
  Map<String, dynamic> diaryEntry,
) async {
  final DateTime date = DateTime.parse(diaryEntry["date"]).toLocal();
  Future<void> Function()? futureDeleteDiaryEntry;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: Builder(
            builder: (context) {
              return AlertDialog(
                backgroundColor: icons[diaryEntry["icon_index"]]["color"]
                    .withAlpha(162),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                title: Center(
                  child: Text(
                    "${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}",
                    style: TextStyle(
                      fontFamily: 'Cursive',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                content: Column(
                  children: [
                    const Divider(color: Colors.white),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "My feeling: ",
                          style: TextStyle(
                            fontFamily: 'Cursive',
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          icons[diaryEntry["icon_index"]]["icon"],
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white),
                    Text(
                      diaryEntry["title"],
                      style: TextStyle(
                        fontFamily: 'Cursive',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        diaryEntry["text"],
                        style: TextStyle(
                          fontFamily: 'Cursive',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        futureDeleteDiaryEntry =
                            () => database.deleteDiaryEntry(diaryEntry["id"]);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Delete the entry',
                        style: TextStyle(
                          color: Color.fromARGB(255, 113, 0, 0),
                          fontFamily: 'Cursive',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
  if (futureDeleteDiaryEntry != null) {
    try {
      await futureDeleteDiaryEntry!();
      return true;
    } catch (error) {
      if (context.mounted) {
        showSnackbar(context, 'Failed to delete diary entry: $error');
      }
      return false;
    }
  }
  return false;
}

Card diaryEntryCard(
  BuildContext context,
  dynamic diaryEntry, {
  required double width,
  required Function() setState,
}) {
  final DateTime date = DateTime.parse(diaryEntry["date"]).toLocal();

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    color: icons[diaryEntry["icon_index"]]["color"].withAlpha(125),
    child: InkWell(
      onTap: () async {
        bool success = await viewDiaryEntry(context, diaryEntry);
        if (success) {
          setState();
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 70.0,
        child: Center(
          child: ListTile(
            leading: SizedBox(
              width: width,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    Text(
                      "${date.day}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Cursive',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      months[date.month - 1],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Cursive',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${date.year}",
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontFamily: 'Cursive',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(width: width / 2),
                  Icon(
                    icons[diaryEntry["icon_index"]]["icon"],
                    color: Colors.white,
                    size: 30.0,
                  ),
                  Text(
                    "  |  ${diaryEntry["title"]}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
