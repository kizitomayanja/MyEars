// ignore_for_file: camel_case_types

import 'dart:async';
//import 'dart:html';

// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_ears/pages/start_listening_ui.dart';

class banner extends StatelessWidget {
  const banner({super.key});

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StartListeningUi()));
    });

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 00, 191, 125),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * (2 / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    image: NetworkImage(
                        "https://raw.githubusercontent.com/kizitomayanja/machineLearning/b26077996bd05a0797e683b76a1fb20365d390eb/Flutter_Project_HCI/myears/images/logo-no-background.png"),
                    fit: BoxFit.contain)),
          ),
        ));
  }
}
