import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';

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
      print("err"); // TODO: Error handling
      return "";
    }
  }

  static Future<Image?> readImageFile(String fileName) async {
    try {
      final file = await localFile(fileName);
      if (await file.exists()) { return Image.file(file, fit: BoxFit.cover, width: double.infinity, height: double.infinity); }
      return null;
    } catch (e) { return null; }
  }

  static Future<File?> copyFile(File source, String fileName) async {
    try {
      final File target = await localFile(fileName);
      return await source.copy(target.path);
    } catch (e) { return null; }
  }

}