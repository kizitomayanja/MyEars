import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_ears/alarm.dart';
import 'package:my_ears/pages/schedule_sessions.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'pages/testing.dart';
import 'pages/banner.dart';

//attempting to configure the database

Future main() async {
  // Initialize FFI
  // sqfliteFfiInit();
  WidgetsFlutterBinding.ensureInitialized();
  Alarmy.init();
  // databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Timer _timer;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Timer _timer;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyEars',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 00, 191, 125)),
        useMaterial3: true,
      ),
      home: banner(), //ScheduleSessions(date: DateTime.now()),
    );
  }
}
