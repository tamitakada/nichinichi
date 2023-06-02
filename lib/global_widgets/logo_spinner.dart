import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';

class LogoSpinner extends StatefulWidget {
  const LogoSpinner({Key? key}) : super(key: key);

  @override
  State<LogoSpinner> createState() => _LogoSpinnerState();
}

class _LogoSpinnerState extends State<LogoSpinner> {
  
  int _currentDot = 0;
  
  List<Widget> _buildLoadingDots() {
    List<Widget> dots = [];
    List<Color> dotColors = [Constants.red, Constants.yellow, Constants.blue];
    for (int i = 0; i < 3; i++) {
      dots.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: AnimatedContainer(
            height: 10,
            width: 10,
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: _currentDot == i ? dotColors[i] : Constants.grey,
              shape: BoxShape.circle
            ),
          ),
        )
      );
    }
    return dots;
  }

  late Timer _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(
        const Duration(milliseconds: 600),
        (timer) => setState(() { _currentDot = (_currentDot + 1) % 3; })
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "NXN",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildLoadingDots()
          )
        ],
      ),
    );
  }
}
