import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'components/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() { _pageNumber = 1; });
            },
            icon: Icon(Icons.add, color: Colors.white,)
          )
        ],
        centerTitle: false,
        title: Text("NICHINICHI", style: Theme.of(context).textTheme.headlineLarge,),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Constants.bgColor,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: _pageNumber == 0
          ? Row(
          children: [
            Expanded(
              flex: 1,
              child: TodoComponent(),
            ),
            SizedBox(width: 20,),
            Expanded(
              flex: 2,
              child: DailyCalendarComponent(),
            )
          ],
        )
        : AddDailyComponent(close: () { setState(() {
          _pageNumber = 0;
        }); }),
      )
    );
  }
}
