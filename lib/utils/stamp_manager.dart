import 'package:flutter/material.dart';

import 'file_utils.dart';
import 'package:nichinichi/constants.dart';

class StampManager {

  static const String _stampFilename = "stamp_image_paths.txt";
  static const Map<CompletionLevel, String> _defaultStamps = {
    CompletionLevel.low: "low",
    CompletionLevel.medium: "medium",
    CompletionLevel.high: "high",
    CompletionLevel.perfect: "perfect"
  };

  static ImageProvider getDefaultStampImage(CompletionLevel level) {
    return AssetImage("assets/${_defaultStamps[level]}.png");
  }

  static Future<ImageProvider> getStampImage(CompletionLevel level) async {
    try {
      String data = await FileUtils.readFile(_stampFilename);
      if (data.isNotEmpty) {
        List<String> stamps = data.split("\n");
        for (int i = 0; i < stamps.length; i++) {
          List<String> stampData = stamps[i].split(",");
          if (stampData.length > 1 && stampData[0] == Constants.levelToString(level)) {
            return FileImage(await FileUtils.localFile(stampData[1]));
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return AssetImage("assets/${_defaultStamps[level]}.png");
  }

}