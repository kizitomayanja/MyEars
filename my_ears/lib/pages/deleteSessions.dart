import 'package:flutter/material.dart';
import 'package:my_ears/alarm.dart';
import 'package:my_ears/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ears/databases/calendarDatabase.dart';

import '../databases/sessions.dart';
import 'history.dart';
import 'calendarUI.dart';
import 'start_listening_ui.dart';

class DeleteSessions extends StatefulWidget {
  final String date;
  const DeleteSessions({super.key, required this.date});

  @override
  State<DeleteSessions> createState() => _DeleteSessionsState();
}

class _DeleteSessionsState extends State<DeleteSessions> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController fromcontroller = TextEditingController();
  late List<Sessions> sessions;

  @override
  void initState() {
    super.initState();
    initializeSessions();
  }

  Future<void> initializeSessions() async {
    try {
      List<Sessions>? temp =
          await CalendarDatabase.getDateSessions(widget.date);
      setState(() {
        sessions = temp ?? List.empty();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error in retrieving dates");
    }
  }

  data name = data();
  Padding _cell(BuildContext context, Sessions session) {
    titlecontroller.text = session.title;
    fromcontroller.text = session.startHour;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: size.height * (0.14),
        width: size.width * (0.8),
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    controller: titlecontroller,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(hintText: session.title),
                  ),
                  TextField(
                    controller: fromcontroller,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: "From",
                    ),
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Container(
                              height: size.height * 0.4,
                              //   decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(30))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    'Are you sure?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          /*int position =
                                              name.getTitlePos(title);
                                          name.date.removeAt(position);
                                          name.title.removeAt(position);
                                          name.to.removeAt(position);
                                          name.duration.removeAt(position);
                                          name.from.removeAt(position);*/
                                          CalendarDatabase.deleteFiles(session);
                                          Alarmy.cancelNotify(session);
                                          Navigator.pop(context);
                                          setState(() {});
                                          Fluttertoast.showToast(
                                              msg: session.title +
                                                  " has been deleted.",
                                              toastLength: Toast.LENGTH_LONG);
                                        },
                                        child: Container(
                                          height: size.height * 0.1,
                                          width: size.width * 0.2,
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
                                            child: Text('Yes'),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Container(
                                          height: size.height * 0.1,
                                          width: size.width * 0.2,
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
                                            child: Text('No'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: const Icon(Icons.delete, color: Colors.red))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              const Expanded(
                  child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'March 16, 2024',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              )),
              Container(
                  height: size.height * (0.5),
                  width: size.width * (0.9),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: sessions.isEmpty
                      ? const Center(
                          child: Text("No sessions yet"),
                        )
                      : ListView.builder(
                          itemCount: sessions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _cell(context, sessions[index]);
                          })),
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
