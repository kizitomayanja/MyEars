//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:my_ears/databases/databasehelper.dart';
import 'package:my_ears/databases/filemanager.dart';
import 'package:my_ears/pages/history.dart';
import 'package:my_ears/pages/calendarUI.dart';
import 'package:my_ears/pages/start_listening_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../databases/files.dart';

class EditTranscript extends StatefulWidget {
  final Files file;
  const EditTranscript(
      {super.key, required this.words, required this.file, required this.type});
  final String words;
  final int type;

  @override
  State<EditTranscript> createState() => _EditTranscriptState();
}

abstract class RawEditorState implements TextSelectionDelegate {
  // Your implementation here
  @override
  bool get lookUpEnabled => true;

  @override
  bool get searchWebEnabled => true;

  @override
  bool get shareEnabled => true;

  // Other members of your RawEditorState class
}

class _EditTranscriptState extends State<EditTranscript> {
//var _controller =quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    //final json = jsonEncode(widget.words);
    setState(() {});
    //_controller.document=Document.fromJson(json);
    //_controller = quillController(document: Document.fromJson(json), selection: null);
  }

  @override
  Widget build(BuildContext context) {
    String trying = widget.words + '\n';
    // String jsonString = r'{"insert":"' + trying + '"}';

    List<dynamic> quillDelta = [
      {"insert": trying}
    ];
    //final word = jsonDecode(quillDelta);
    final size = MediaQuery.of(context).size;
    //final json = jsonDecode(widget.words);
    //final String json = jsonEncode(word);
    //   final del = delta.Delta()..insert(widget.words);
    final document = Document.fromJson(quillDelta);
    // _controller.document.insert(0, widget.words);
    QuillController _controller = QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0));

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 00, 191, 125),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'EDIT',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                height: size.height * (0.5),
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      QuillToolbar.simple(
                          configurations: QuillSimpleToolbarConfigurations(
                              multiRowsDisplay: false,
                              buttonOptions:
                                  const QuillSimpleToolbarButtonOptions(
                                      base: QuillToolbarBaseButtonOptions(
                                iconSize: 20,
                                iconButtonFactor: 1.4,
                              )),
                              controller: _controller,
                              sharedConfigurations:
                                  const QuillSharedConfigurations(
                                      locale: Locale("en")))),
                      Expanded(
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                              readOnly: false,
                              controller: _controller,
                              sharedConfigurations:
                                  const QuillSharedConfigurations(
                                      locale: Locale('en'))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.edit_note, color: Colors.white),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: Container(
                                  height: size.height * 0.4,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg: "Saved",
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                              Files fileupdate = Files(
                                                  file: _controller
                                                      .getPlainText(),
                                                  id: widget.file.id,
                                                  title: widget.file.title);
                                              if (widget.type == 1) {
                                                DatabaseHelper.addFiles(
                                                    fileupdate);
                                                FileManager.writeToTxtFile(
                                                    fileupdate,
                                                    _controller.getPlainText());
                                              } else {
                                                DatabaseHelper.updateFiles(
                                                    fileupdate);
                                                FileManager.writeToTxtFile(
                                                    fileupdate,
                                                    _controller.getPlainText());
                                              }

                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: size.height * 0.09,
                                              width: size.width * 0.25,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  gradient:
                                                      const LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        Colors.yellow,
                                                        Colors.green
                                                      ])),
                                              child: const Center(
                                                  child: Text(
                                                'Save',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "File has been exported as file.pdf",
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: size.height * 0.09,
                                              width: size.width * 0.25,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  gradient:
                                                      const LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        Colors.yellow,
                                                        Colors.green
                                                      ])),
                                              child: const Center(
                                                  child: Text(
                                                'Export as PDF',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "File has been exported as file.txt",
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: size.height * 0.09,
                                              width: size.width * 0.25,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  gradient:
                                                      const LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        Colors.yellow,
                                                        Colors.green
                                                      ])),
                                              child: const Center(
                                                  child: Text(
                                                'Export as Txt',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(Icons.save_as)),
                ],
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
          )),
    ));
  }
}
