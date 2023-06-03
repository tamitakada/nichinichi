import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/file_utils.dart';
import 'package:nichinichi/constants.dart';

class StampManager {

  static const Map<CompletionLevel, String> _defaultStamps = {
    CompletionLevel.low: "low",
    CompletionLevel.medium: "medium",
    CompletionLevel.high: "high",
    CompletionLevel.perfect: "perfect"
  };

  static Image getDefaultStampImage(CompletionLevel level) {
    return Image.asset("assets/${_defaultStamps[level]}.png", fit: BoxFit.cover, width: double.infinity, height: double.infinity);
  }

  static Future<File?> updateStampImage(CompletionLevel level, File imageFile) async {
    try {
      File? file = await FileUtils.copyFile(imageFile, "stamp-$level");
      return file;
    } catch (e) { return null; }
  }

  static Future<Image?> getStampImage(CompletionLevel level) async {
    try { return await FileUtils.readImageFile("stamp-$level"); }
    catch (e) { return null; }
  }

}