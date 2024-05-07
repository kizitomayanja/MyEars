import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ears/databases/calendarDatabase.dart';
import 'package:my_ears/pages/editSchedule.dart';
import 'package:my_ears/pages/deleteSessions.dart';
import 'package:my_ears/pages/schedule_sessions.dart';
import 'package:table_calendar/table_calendar.dart';

import 'history.dart';
import 'start_listening_ui.dart';

class CalendarUi extends StatefulWidget {
  const CalendarUi({super.key});

  @override
  State<CalendarUi> createState() => _CalendarUiState();
}

class _CalendarUiState extends State<CalendarUi> {
  DateTime today = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String formatDate(DateTime dateTime) {
    // Extract year, month, and day components from the DateTime variable
    String year = dateTime.year.toString().padLeft(4, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');

    // Concatenate the components with hyphens to form the desired format
    return '$year-$month-$day';
  }

  @override
  void initState() {
    super.initState();
    getDates();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    if (isSameDay(day, today)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EditSchedule(
                    date: today,
                  )));
    }
    setState(() {
      today = day;
      _selectedDay = focusedDay;
    });
  }

  List<DateTime> toHighlight = List.empty(growable: true);

  Future<void> getDates() async {
    List<String>? dates = await CalendarDatabase.getUniqueDates();

    if (dates == null) {
      Fluttertoast.showToast(msg: "There is nothing in toHighligh");
      setState(() {
        toHighlight = List.empty(growable: true);
      });
      return;
    }

    List<DateTime> tempDates = [];
    for (String date in dates) {
      String dateString =
          '2022-5-5'; // Example date string in the format 'yyyy-m-d'
      List<String> dateParts =
          date.split('-'); // Split the string into year, month, and day parts

// Ensure that the dateParts list contains exactly 3 parts
      if (dateParts.length == 3) {
        int? year = int.tryParse(dateParts[0]); // Parse year part
        int? month = int.tryParse(dateParts[1]); // Parse month part
        int? day = int.tryParse(dateParts[2]); // Parse day part

        // Check if parsing was successful for all parts
        if (year != null && month != null && day != null) {
          DateTime dateTime =
              DateTime(year, month, day); // Create DateTime object
          tempDates.add(
              dateTime); //print(dateTime); // Output: 2022-05-05 00:00:00.000
        } else {
          Fluttertoast.showToast(msg: 'Invalid date format');
        }
      } else {
        Fluttertoast.showToast(msg: 'Invalid date format2');
      }

      //DateTime temp = DateTime.parse(date);
    }
    Fluttertoast.showToast(msg: "There is something in toHighligh");
    setState(() {
      toHighlight = tempDates;
    });
  }

  TableCalendar _tableCalendar() {
    //
    CalendarFormat _calendarFormat = CalendarFormat.month;
    return TableCalendar(
      rowHeight: 43,
      headerStyle:
          const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: today,
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      selectedDayPredicate: (day) {
        return isSameDay(day, today);
      },
      onDaySelected: _onDaySelected,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (toHighlight != null) {
            for (DateTime d in toHighlight!) {
              if (day.day == d.day &&
                  day.month == d.month &&
                  day.year == d.year) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            }
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 191, 125),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SCHEDULE',
                    style: TextStyle(
                        fontFamily: 'comic neune', fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: size.height * (1 / 7),
                    width: size.width * (1 / 4),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Image(
                        image: NetworkImage(
                            "https://raw.githubusercontent.com/kizitomayanja/machineLearning/b26077996bd05a0797e683b76a1fb20365d390eb/Flutter_Project_HCI/myears/images/logo-no-background.png"),
                        fit: BoxFit.contain),
                  ),
                ],
              ),
              Container(
                height: size.height * (0.525),
                width: size.width,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _tableCalendar(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DeleteSessions(
                                date: formatDate(_selectedDay))));
                  },
                  child: Container(
                    height: size.height * (0.06),
                    width: size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Center(
                        child: Text('Delete Session',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: size.height * 0.01,
                    left: size.height * 0.018,
                    right: size.height * 0.018),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ScheduleSessions(
                                date: _selectedDay,
                              ))),
                  child: Container(
                    height: size.height * (0.06),
                    width: size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Center(
                        child: Text('New Session',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CalendarUi())),
                      child: Icon(
                        Icons.calendar_month,
                        size: size.height * 0.08,
                      )),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const StartListeningUi())),
                      child: Icon(
                        Icons.home,
                        size: size.height * 0.08,
                      )),
                  GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const History())),
                      child: Icon(
                        Icons.work_history,
                        size: size.height * 0.08,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
