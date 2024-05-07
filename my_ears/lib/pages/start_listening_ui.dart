import 'package:flutter/material.dart';
import 'package:my_ears/pages/transcribingUI.dart';

import 'history.dart';
import 'calendarUI.dart';

class StartListeningUi extends StatefulWidget {
  const StartListeningUi({super.key});

  @override
  State<StartListeningUi> createState() => _StartListeningUiState();
}

class _StartListeningUiState extends State<StartListeningUi> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 00, 191, 125),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('HOME',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                  )
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.mic,
                        size: 80,
                      ),
                    ),
                    SizedBox(
                      height: size.height * (0.01),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TranscribingUi()));
                      },
                      child: const Text(
                        'Start Recording?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
