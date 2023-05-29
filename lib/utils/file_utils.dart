import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileUtils {

  // Path Finding

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  // File Read/Write

  static Future<File> writeToFile(String data, String fileName) async {
    final file = await localFile(fileName);
    return file.writeAsString(data);
  }

  static Future<String> readFile(String fileName) async {
    try {
      final file = await localFile(fileName);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("ERROR!"); // TODO: Error handling
      return "";
    }
  }

}