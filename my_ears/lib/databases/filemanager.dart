import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ears/databases/files.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  // Function to write text to a .txt file
  static Future<void> writeToTxtFile(Files file, String text) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = file.filepath;
      final fileHandle = File(filepath);

      await Directory(directory.path).create(recursive: true);

      // Create the file if it doesn't exist
      // final fileHandle = File(filepath);
      if (!fileHandle.existsSync()) {
        await fileHandle.create(recursive: true);
      }
      // Write the text to the file
      await fileHandle.writeAsString(text);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error writing to file: $e');
    }
  }

  // Function to read text from a .txt file
  static Future<String> readFromTxtFile(Files file) async {
    try {
      final filepath = file.filepath;
      final fileHandle = File(filepath);

      // Read text from the file
      String fileContents = await fileHandle.readAsString();
      return fileContents;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error reading from file: $e');
      return " Nothing to show ";
    }
  }

  static Future<void> deleteFile(Files file) async {
    try {
      final filepath = file.filepath;
      final fileHandle = File(filepath);

      // Check if the file exists before attempting to delete it
      if (await fileHandle.exists()) {
        await fileHandle.delete();
        Fluttertoast.showToast(msg: 'File deleted successfully: $filepath');
      } else {
        Fluttertoast.showToast(msg: 'File does not exist: $filepath');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting file');
    }
  }
}
