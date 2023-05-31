import 'package:flutter/material.dart';
import 'dart:io';
import 'file_utils.dart';
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

  static Future<Image> updateStampImage(CompletionLevel level, File imageFile) async {
    try {
      File? file = await FileUtils.copyFile(imageFile, "stamp-$level");
      if (file != null) {
        return Image.file(file, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
      }
      return getDefaultStampImage(level);
    }
    catch (e) { return getDefaultStampImage(level); }
  }

  static Future<Image> getStampImage(CompletionLevel level) async {
    try {
      Image? image = await FileUtils.readImageFile("stamp-$level");
      if (image != null) { return image; }
      else { return getDefaultStampImage(level); }
    } catch (e) {
      return getDefaultStampImage(level);
    }
  }

}