import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_ears/alarm.dart';
import 'package:my_ears/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ears/databases/calendarDatabase.dart';
//This UI is meant to allow a user to add more sessions to a specific date
import '../databases/sessions.dart';
import 'history.dart';
import 'calendarUI.dart';
import 'start_listening_ui.dart';

class ScheduleSessions extends StatefulWidget {
  final DateTime date;
  const ScheduleSessions({super.key, required this.date});

  @override
  State<ScheduleSessions> createState() => _ScheduleSessionsState();
}

class _ScheduleSessionsState extends State<ScheduleSessions> {
  data name = data();
  late TimeOfDay _selectedTime;
  late TimeOfDay _selectedEndTime;
  @override
  void initState() {
    super.initState();
    getSessions();
    _selectedTime = TimeOfDay.now();
    _selectedEndTime = TimeOfDay(
        hour: TimeOfDay.now().hour + 2, minute: TimeOfDay.now().minute);
  }

  late List<Sessions>? sessions;

  Future<void> getSessions() async {
    String dateFormat =
        "${widget.date.year}-${widget.date.month}-${widget.date.day}";
    List<Sessions>? temp = await CalendarDatabase.getDateSessions(dateFormat);
    if (temp != null) {
      Fluttertoast.showToast(msg: "There is data");
      setState(() {
        sessions = temp;
      });
    } else {
      Fluttertoast.showToast(msg: "There is no data");
      setState(() {
        sessions = List.empty(growable: true);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool section) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: section ? _selectedTime : _selectedEndTime,
    );
    if (section == true) {
      if (picked != null && picked != _selectedTime) {
        setState(() {
          _selectedTime = picked;
        });
      }
    } else {
      if (picked != null && picked != _selectedEndTime) {
        setState(() {
          _selectedEndTime = picked;
        });
      }
    }
  }

  Padding _cell(BuildContext context, String title, String time,
      String duration, Sessions session) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: size.height * (0.14),
        width: size.width * (0.8),
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      duration,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int timeOfDayToMinutes(TimeOfDay timeOfDay) {
    return timeOfDay.hour * 60 + timeOfDay.minute;
  }

  Future<void> save(String text) async {
    String startHour = '${_selectedTime.hour} ${_selectedTime.minute} hrs';
    String endHour = '${_selectedEndTime.hour} ${_selectedEndTime.minute} hrs';
    Sessions session = Sessions(
        title: text,
        date: '${widget.date.year}-${widget.date.month}-${widget.date.day}',
        startHour: startHour,
        endHour: endHour,
        id: DateTime.now().day +
            DateTime.now().minute +
            DateTime.now().microsecond);
    int rowsAffected = await CalendarDatabase.addFiles(session);
    Alarmy.notify(session);
    //Fluttertoast.showToast(msg: "$rowsAffected row(s) affected.");
  }

  @override
  Widget build(BuildContext context) {
    String datetoday =
        '${widget.date.year}-${widget.date.month}-${widget.date.day}';
    Fluttertoast.showToast(msg: datetoday);
    String time =
        '${widget.date.year} ${name.months[widget.date.month - 1]}, ${widget.date.day}';
    final size = MediaQuery.of(context).size;
    TextEditingController titleController = TextEditingController();
    //TextEditingController fromController = TextEditingController();
    //TextEditingController toController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 191, 125),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SESSIONS',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'comic neune',
                        fontWeight: FontWeight.bold),
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
              Text(
                time,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                  height: size.height * (0.5),
                  width: size.width * (0.9),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: sessions != null
                      ? ListView.builder(
                          itemCount: sessions!.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index != sessions!.length) {
                              return _cell(
                                  context,
                                  sessions![index].title,
                                  sessions![index].startHour,
                                  sessions![index].endHour,
                                  sessions![index]);
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  content: Container(
                                                    height: size.height * 0.4,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height:
                                                                size.height *
                                                                    0.2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      "Title:",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          20,
                                                                      width: size
                                                                              .width *
                                                                          0.5,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Colors.white),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            titleController,
                                                                        decoration:
                                                                            InputDecoration(hintText: "Enter the title..."),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      "From:",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          20,
                                                                      width: size
                                                                              .width *
                                                                          0.5,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Colors.white),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          _selectTime(
                                                                              context,
                                                                              true); // Call time picker here
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          _selectedTime != null
                                                                              ? '${_selectedTime.hour}:${_selectedTime.minute} hrs'
                                                                              : 'Select Starting Time',
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      "To:",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          30,
                                                                      width: size
                                                                              .width *
                                                                          0.5,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Colors.white),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          _selectTime(
                                                                              context,
                                                                              false); // Call time picker here
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          _selectedEndTime != null
                                                                              ? '${_selectedEndTime.hour}:${_selectedEndTime.minute} hrs'
                                                                              : 'Select Ending Time',
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              /*  name.title.add("Mobile App");
                              name.date.add("March 16, 2024");
                              name.from.add("8:00 AM");
                              name.to.add("10:00 AM");
                              name.duration.add("2 hrs");*/
                                                              final duration = Duration(
                                                                  minutes: timeOfDayToMinutes(
                                                                          _selectedEndTime) -
                                                                      timeOfDayToMinutes(
                                                                          _selectedTime));

                                                              TimeOfDay now = TimeOfDay
                                                                  .fromDateTime(
                                                                      widget
                                                                          .date);

                                                              try {
                                                                save(titleController
                                                                    .text
                                                                    .toString());
                                                              } catch (e) {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        'Error: $e',
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG);
                                                              }

                                                              Fluttertoast
                                                                  .showToast(
                                                                msg: duration
                                                                            .inMinutes >
                                                                        59
                                                                    ? "${duration.inMinutes ~/ 60} hours ${duration.inMinutes % 60} mins"
                                                                    : "${duration.inMinutes} mins",
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                              );
                                                              Navigator.pop(
                                                                  context);

                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          ScheduleSessions(
                                                                              date: widget.date)));
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              height:
                                                                  size.height *
                                                                      0.1,
                                                              width:
                                                                  size.width *
                                                                      0.3,
                                                              decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30)),
                                                                  gradient: LinearGradient(
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment.bottomRight,
                                                                      colors: [
                                                                        Colors
                                                                            .yellow,
                                                                        Colors
                                                                            .green
                                                                      ])),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  "DONE",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: const Icon(Icons
                                            .add_circle_outline_outlined))),
                              );
                            }
                          })
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              content: Container(
                                                height: size.height * 0.4,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height:
                                                            size.height * 0.2,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  "Title:",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Container(
                                                                  height: 20,
                                                                  width:
                                                                      size.width *
                                                                          0.5,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                          color:
                                                                              Colors.white),
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        titleController,
                                                                    decoration: InputDecoration(
                                                                        hintText:
                                                                            "Enter the title..."),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  "From:",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Container(
                                                                  height: 20,
                                                                  width:
                                                                      size.width *
                                                                          0.5,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                          color:
                                                                              Colors.white),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      _selectTime(
                                                                          context,
                                                                          true); // Call time picker here
                                                                    },
                                                                    child: Text(
                                                                      _selectedTime !=
                                                                              null
                                                                          ? '${_selectedTime.hour}:${_selectedTime.minute} hrs'
                                                                          : 'Select Starting Time',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  "To:",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Container(
                                                                  height: 20,
                                                                  width:
                                                                      size.width *
                                                                          0.5,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                          color:
                                                                              Colors.white),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      _selectTime(
                                                                          context,
                                                                          false); // Call time picker here
                                                                    },
                                                                    child: Text(
                                                                      _selectedEndTime !=
                                                                              null
                                                                          ? '${_selectedEndTime.hour}:${_selectedEndTime.minute} hrs'
                                                                          : 'Select Ending Time',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          /*  name.title.add("Mobile App");
                                name.date.add("March 16, 2024");
                                name.from.add("8:00 AM");
                                name.to.add("10:00 AM");
                                name.duration.add("2 hrs");*/
                                                          final duration = Duration(
                                                              minutes: timeOfDayToMinutes(
                                                                      _selectedEndTime) -
                                                                  timeOfDayToMinutes(
                                                                      _selectedTime));

                                                          TimeOfDay now =
                                                              TimeOfDay
                                                                  .fromDateTime(
                                                                      widget
                                                                          .date);
                                                          try {
                                                            save(titleController
                                                                .text
                                                                .toString());
                                                          } catch (e) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Error: $e',
                                                                toastLength: Toast
                                                                    .LENGTH_LONG);
                                                          }

                                                          Fluttertoast
                                                              .showToast(
                                                            msg: duration
                                                                        .inMinutes >
                                                                    59
                                                                ? "${duration.inMinutes ~/ 60} hours ${duration.inMinutes % 60} mins"
                                                                : "${duration.inMinutes} mins",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          height:
                                                              size.height * 0.1,
                                                          width:
                                                              size.width * 0.3,
                                                          decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30)),
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment.bottomRight,
                                                                  colors: [
                                                                    Colors
                                                                        .yellow,
                                                                    Colors.green
                                                                  ])),
                                                          child: const Center(
                                                            child: Text(
                                                              "DONE",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: const Icon(
                                      Icons.add_circle_outline_outlined,
                                      size: 40,
                                    ))),
                          ),
                        )

                  /*
                           ListView(
                            children: [
                            _cell(context, "HCI Lecture", "8:00 AM", "2 hrs"),
                            _cell(context, "Microprocessors", "10:00 AM", "3 hrs"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: 
                                  GestureDetector(
                                  onTap: (){
                                    showDialog(context: context, builder: (_){
                                      return AlertDialog(
                                        content: Container(
                                          height: size.height*0.4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                              Container(
                                                height: size.height*0.2,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("Title:",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        height: 20,
                                                        width: size.width*0.5,
                                                        decoration: BoxDecoration(color: Colors.white),
                                                        child: Text("Mobile App"),
                                                      )
                                                    ],),
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("From:",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        height: 20,
                                                        width: size.width*0.5,
                                                        decoration: BoxDecoration(color: Colors.white),
                                                        child: Text("9:00 AM"),
                                                      )
                                                    ],),
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("To:",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        height: 20,
                                                        width: size.width*0.5,
                                                        decoration: BoxDecoration(color: Colors.white),
                                                        child: Text("11:00 AM"),
                                                      )
                                                    ],),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  
                                                },


                                                child: Container(
                                                  height: size.height*0.1,
                                                  width: size.width*0.3,
                                                  decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                                            gradient: LinearGradient(
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                              colors: [
                                                                Colors.yellow,
                                                                Colors.green
                                                              ]
                                                            )
                                                          ),
                                                  child: Center(child: Text("DONE",style: TextStyle(fontWeight: FontWeight.bold),),),
                                                ),
                                              )
                                            ],),
                                          ),
                                        ),

                                      );

                                    });
                                  },
                                  child: Icon(Icons.add_circle_outline_outlined))
                                ),
                              ),
            
                              
            
            
                            ],
                          ),*/
                  ),
              const Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CalendarUi()));
                      },
                      child: Icon(
                        Icons.calendar_month,
                        size: size.height * 0.08,
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const StartListeningUi()));
                      },
                      child: Icon(
                        Icons.home,
                        size: size.height * 0.08,
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const History()));
                      },
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
