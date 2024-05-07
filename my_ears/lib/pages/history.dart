import 'package:flutter/material.dart';
import 'package:my_ears/databases/databasehelper.dart';
import 'package:my_ears/databases/filemanager.dart';
import 'package:my_ears/databases/files.dart';
import 'package:my_ears/pages/EditTranscript.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'calendarUI.dart';
import 'start_listening_ui.dart';
import 'package:my_ears/data.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  data name = data();
  //int _count = 0;
  List<Files> _dbfiles = [];
  DatabaseHelper db = DatabaseHelper();
  String wordstouse = "";

  Future<void> getWords(Files file) async {
    String temp = await FileManager.readFromTxtFile(file);
    setState(() {
      wordstouse = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeList();
  }

  Future<void> initializeList() async {
    try {
      List<Files>? files = await DatabaseHelper.getAllFiles();
      setState(() {
        _dbfiles = files ?? List.empty(growable: true);
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error retrieving files: $e", toastLength: Toast.LENGTH_LONG);
      // Handle error loading files
    }
  }

  Padding _cell(BuildContext context, String _title, String _date, Files file) {
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
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _date,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                width: size.width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          getWords(file);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditTranscript(
                                        words: wordstouse,
                                        file: file,
                                        type: 2,
                                      )));
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 30,
                        )),
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
                                                DatabaseHelper.deleteFiles(
                                                    file);
                                                FileManager.deleteFile(file);
                                                getList();
                                                Navigator.pop(context);
                                                setState(() {});
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "$_title has been deleted.",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    fontSize: 20,
                                                    textColor: Colors.white,
                                                    backgroundColor:
                                                        Colors.black);
                                              },
                                              child: Container(
                                                height: size.height * 0.1,
                                                width: size.width * 0.2,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
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
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Container(
                                                height: size.height * 0.1,
                                                width: size.width * 0.2,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
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
                        child: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 151, 17, 7),
                          size: 30,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getList() async {
    try {
      List<Files>? files = await DatabaseHelper.getAllFiles();
      setState(() {
        _dbfiles = files ?? List.empty(growable: true);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating files");
      // Handle error loading files
    }
  }
/*
void getListLength() async{
  return await getList().then((value) {
    setState(() {
      _count = value!.length;
    });
    //return value!.length;
  });
}*/

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // getList();

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
              const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 13),
                    child: Text(
                      'March 16, 2024',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )),
              Container(
                height: size.height * (0.5),
                width: size.width * (0.9),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: _dbfiles.isEmpty
                    ? const Center(child: Text("No Files yet"))
                    : ListView.builder(
                        itemCount: _dbfiles.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _cell(context, _dbfiles[index].title,
                              _dbfiles[index].file.toString(), _dbfiles[index]);
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
