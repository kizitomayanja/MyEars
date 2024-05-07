import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ears/data.dart';

class testing extends StatefulWidget {
  final DateTime date;
  const testing({super.key, required this.date});

  @override
  State<testing> createState() => _testingState();
}

class _testingState extends State<testing> {
  late TimeOfDay _selectedTime;
  late TimeOfDay _selectedEndTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
    _selectedEndTime = TimeOfDay(
        hour: TimeOfDay.now().hour + 2, minute: TimeOfDay.now().minute);
  }

  Future<void> _selectTime(BuildContext context, bool section) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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

  @override
  Widget build(BuildContext context) {
    data name = data();
    final size = MediaQuery.of(context).size;
    TextEditingController titleController = TextEditingController();
    // Your existing code...
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Title:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      height: 20,
                                      width: size.width * 0.5,
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: TextField(
                                        controller: titleController,
                                        decoration: const InputDecoration(
                                          hintText: "Enter the title...",
                                        ),
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      height: 20,
                                      width: size.width * 0.5,
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: GestureDetector(
                                        onTap: () {
                                          _selectTime(context,
                                              true); // Call time picker here
                                        },
                                        child: Text(
                                          _selectedTime != null
                                              ? '${_selectedTime.hour}:${_selectedTime.minute}'
                                              : 'Select Starting Time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "To:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      height: 20,
                                      width: size.width * 0.5,
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: GestureDetector(
                                        onTap: () {
                                          _selectTime(context,
                                              false); // Call time picker here
                                        },
                                        child: Text(
                                          _selectedEndTime != null
                                              ? '${_selectedEndTime.hour}:${_selectedEndTime.minute}'
                                              : 'Select Ending Time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Container(
                              height: size.height * 0.1,
                              width: size.width * 0.3,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.yellow, Colors.green],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "DONE",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add_circle_outline_outlined),
        ),
      ),
    );
    // Your existing code...
  }
}
