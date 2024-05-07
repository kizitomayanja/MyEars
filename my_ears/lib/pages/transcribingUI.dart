import 'dart:async';
/*import 'dart:ffi';

import 'package:cheetah_flutter/cheetah.dart';
import 'package:cheetah_flutter/cheetah_error.dart';
import 'package:flutter_voice_processor/flutter_voice_processor.dart';*/
// ignore: unnecessary_import
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ears/cheetah_manager.dart';
import 'package:my_ears/databases/files.dart';
import 'package:my_ears/pages/editTranscript.dart';
//import 'package:speech_to_text/speech_to_text.dart';

import 'history.dart';
import 'calendarUI.dart';
import 'start_listening_ui.dart';

class TranscribingUi extends StatefulWidget {
  const TranscribingUi({super.key});

  @override
  State<TranscribingUi> createState() => _TranscribingUiState();
}

class _TranscribingUiState extends State<TranscribingUi> {
  final Color myEarsTheme = const Color.fromARGB(255, 00, 191, 125);
  bool _isListening = false;
  // final SpeechToText _speechToText = SpeechToText();
  String accesskey = "2pW99F6hYGerPdTVDur/dDuQUirjpOkWqssx8vcUJ4xeJHLxV64JGA==";
  String model = "assets/cheetah_params.pv";
  late CheetahManager _cheetahManager;
  //CheetahManager cheetahManager = CheetahManager.create(accesskey, modelPath, (transcript) => null, (error) => null)

  // bool _speechEnabled = true;
  // String _wordsSpoken = "";
  String _transcript = "";
  //String _finalWords = "";
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeCheetahManager();
  }

  Future<void> initializeCheetahManager() async {
    try {
      _cheetahManager =
          await CheetahManager.create(accesskey, model, onTranscript, onError);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error initializing cheetah");
    }
  }

  void onTranscript(String transcript) {
    print('Transcript: $transcript');
    setState(() {
      _transcript += transcript; // Update transcript state
    });
  }

  void _startRecording() async {
    await _cheetahManager.startProcess();
    setState(() {
      _isListening = true;
    });
  }

  void _stopRecording() async {
    await _cheetahManager.stopProcess();
    setState(() {
      _isListening = false;
    });
  }
/*
  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
      //_confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _listen(bool condition) async {
    Timer timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _finalWords += _wordsSpoken;
      });
      if (_speechToText.isListening) {
        _speechToText.stop;
      }
      _speechToText.listen;
    });
    if (condition == false) {
      timer.cancel();
    }
  }*/

  void onError(dynamic error) {
    Fluttertoast.showToast(msg: error);
    // Handle error (e.g., display error message)
  }

/*
  void _onSpeechResult(result) {
    setState(() {
      //String _newLine = "\n";
      _wordsSpoken = "${result.recognizedWords}";
      //_confidenceLevel = result.confidence;
    });
  }
*/

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String titled = "";
    final size = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: myEarsTheme,
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: width * 0.15,
                      child: Text(
                        _isListening ? "Listening" : "Paused",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'comic neue'),
                      )),
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Icon(_isListening
                        ? Icons.mic_rounded
                        : Icons.mic_off_rounded),
                  ),
                  Container(
                    height: height * (1 / 7),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Image(
                        image: NetworkImage(
                            "https://raw.githubusercontent.com/kizitomayanja/machineLearning/b26077996bd05a0797e683b76a1fb20365d390eb/Flutter_Project_HCI/myears/images/logo-no-background.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                  height: height * 0.55,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        _transcript,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  )),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: width * 0.3,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              heroTag: 'stop',
                              onPressed: () {
                                _stopRecording();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    //TextEditingController controller = TextEditingController();
                                    return AlertDialog(
                                      title: const Text('Transcript Title'),
                                      content: Container(
                                        height: size.height * 0.5,
                                        width: size.width * 0.7,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        child: TextField(
                                          controller: myController,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'Enter Title',
                                              hintText: 'Enter the Title'),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Approve'),
                                          onPressed: () {
                                            titled = myController.text;
                                            //myController.dispose();
                                            Navigator.of(context).pop();
                                            DateTime use = DateTime.now();
                                            int id = use.day +
                                                use.hour +
                                                use.minute +
                                                use.millisecond;
                                            Files file = Files(
                                                file: _transcript,
                                                id: id,
                                                title: titled);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        EditTranscript(
                                                          words: _transcript,
                                                          file: file,
                                                          type: 1,
                                                        )));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Icon(Icons.stop_circle),
                            ),
                            const Text("Stop")
                          ],
                        ),
                      ),
                      Container(
                        width: width * 0.3,
                        child: Column(
                          children: [
                            FloatingActionButton(
                                heroTag: 'play',
                                onPressed: _isListening
                                    ? _stopRecording
                                    : _startRecording,
                                child: Icon(_isListening
                                    ? Icons.pause
                                    : Icons.play_arrow)),
                            Text(_isListening ? "Pause" : "Play")
                          ],
                        ),
                      )
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
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const History())),
                          child: Icon(
                            Icons.work_history,
                            size: size.height * 0.08,
                          )),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
