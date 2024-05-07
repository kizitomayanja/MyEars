import 'package:flutter/material.dart';
import 'package:my_ears/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ears/databases/calendarDatabase.dart';

import '../databases/sessions.dart';
import 'history.dart';
import 'calendarUI.dart';
import 'start_listening_ui.dart';

class EditSchedule extends StatefulWidget {
  const EditSchedule({super.key, required this.date});
  final DateTime date;

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  data name = data();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSessions();
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

  Padding _cell(
      BuildContext context, String title, String time, Sessions session) {
    final size = MediaQuery.of(context).size;
    DateTime today = widget.date;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: size.height * (0.14),
        width: size.width * (0.8),
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    String startTime = session.startHour;
                    String endTime = session.endHour;
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Container(
                              height: size.height * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: size.height * 0.2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Title:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(
                                                height: 20,
                                                width: size.width * 0.5,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(session.title),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "From:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(
                                                height: 20,
                                                width: size.width * 0.5,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(time),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "To:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(
                                                height: 20,
                                                width: size.width * 0.5,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: Text(name.to[
                                                    name.title.indexOf(title)]),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                            msg: title + " has been edited.",
                                            toastLength: Toast.LENGTH_LONG);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: size.height * 0.1,
                                        width: size.width * 0.3,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.yellow,
                                                  Colors.green
                                                ])),
                                        child: const Center(
                                          child: Text(
                                            "DONE",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                    Icons.edit,
                    size: 30,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime today = widget.date;
    String time = today.year.toString() +
        ' ' +
        name.months[today.month - 1] +
        ', ' +
        today.day.toString();
    return Scaffold(
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
                        fontFamily: 'comic neune',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
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
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                height: size.height * (0.5),
                width: size.width * (0.9),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ListView.builder(
                  itemCount: sessions?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _cell(context, sessions![index].title,
                        sessions![index].startHour, sessions![index]);
                  },
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
