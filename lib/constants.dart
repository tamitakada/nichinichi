import 'package:flutter/material.dart';

enum CompletionLevel {
  noData,
  none,
  low,
  medium,
  high,
  perfect
}

enum ErrorType {
  save,
  fetch,
  fileRead,
  fileWrite,
  other
}

class Constants {
  
  static const bgColor = Color.fromRGBO(45, 45, 45, 1);
  static const grey = Color.fromRGBO(60, 60, 60, 1);
  static const blue = Color.fromRGBO(94, 220, 228, 1);
  static const green = Color.fromRGBO(139, 223, 56, 1);
  static const yellow = Color.fromRGBO(228, 220, 16, 1);
  static const red = Color.fromRGBO(251, 74, 74, 1);

  static const monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  static String errorToString(ErrorType type) {
    switch (type) {
      case ErrorType.save: return "Unable to Save Data";
      case ErrorType.fetch: return "Unable to Get Data";
      case ErrorType.fileRead: return "Unable to Read Data";
      case ErrorType.fileWrite: return "Unable to Write Data";
      case ErrorType.other: return "Unable to Load Data";
    }
  }

  static String levelToString(CompletionLevel level) {
    switch (level) {
      case CompletionLevel.noData: return "No Data";
      case CompletionLevel.none: return "Skipped";
      case CompletionLevel.low: return "Low";
      case CompletionLevel.medium: return "Medium";
      case CompletionLevel.high: return "High";
      case CompletionLevel.perfect: return "Perfect";
    }
  }

  static int levelToInt(CompletionLevel level) {
    switch (level) {
      case CompletionLevel.noData: return 0;
      case CompletionLevel.none: return 0;
      case CompletionLevel.low: return 0;
      case CompletionLevel.medium: return 50;
      case CompletionLevel.high: return 75;
      case CompletionLevel.perfect: return 100;
    }
  }

  static String getLevelPercentageString(CompletionLevel level) {
    int levelInt = levelToInt(level);
    switch (level) {
      case CompletionLevel.noData: return "No Data";
      case CompletionLevel.none: return "$levelInt% complete";
      case CompletionLevel.low: return ">$levelInt% complete";
      case CompletionLevel.medium: return ">$levelInt% complete";
      case CompletionLevel.high: return ">$levelInt% complete";
      case CompletionLevel.perfect: return "$levelInt% complete";
    }
  }

  static Color getLevelColor(CompletionLevel level) {
    switch (level) {
      case CompletionLevel.noData: return grey;
      case CompletionLevel.none: return red;
      case CompletionLevel.low: return red;
      case CompletionLevel.medium: return yellow;
      case CompletionLevel.high: return green;
      case CompletionLevel.perfect: return blue;
    }
  }
  
}