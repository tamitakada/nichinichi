import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/data_management/data_manager.dart';
import 'package:nichinichi/models/models.dart';
import 'components/components.dart';
import 'package:nichinichi/global_widgets/logo_spinner.dart';
import 'package:nichinichi/overlay_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements OverlayManager {

  Future<TodoList?> _list = DataManager.getTodaysList();
  ValueNotifier<Widget?> _overlayChild = ValueNotifier<Widget?>(null);

  void updateList() { setState(() { _list = DataManager.getTodaysList(); }); }

  @override
  void updateOverlay(Widget? child) { _overlayChild.value = child; }

  @override
  bool isOverlayOpen() { return _overlayChild.value != null; }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text("NICHINICHI", style: Theme.of(context).textTheme.headlineLarge,),
            backgroundColor: Constants.bgColor,
            elevation: 0,
          ),
          backgroundColor: Constants.bgColor,
          body: FutureBuilder<TodoList?>(
            future: _list,
            builder: (BuildContext context, AsyncSnapshot<TodoList?> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Container(
                    key: UniqueKey(),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: TodoComponent(list: snapshot.data!, updateList: updateList)),
                        const SizedBox(width: 20),
                        Flexible(
                          flex: 2,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: DailyComponent(manager: this, updateTodoList: updateList)
                          ),
                        ),
                      ],
                    )
                  );
                } else { return const Text("Error"); }
              } else { return const Center(child: LogoSpinner()); }
            },
          )
        ),
        ValueListenableBuilder<Widget?>(
          valueListenable: _overlayChild,
          builder: (BuildContext context, Widget? overlayChild, _) {
            return overlayChild != null ? GestureDetector(
              onTap: () => _overlayChild.value = null,
              child: Stack(
                children: [
                  Container(
                    height: double.infinity, 
                    width: double.infinity,
                    color: Colors.transparent
                  ),
                  overlayChild
                ],
              ),
            ) : Container();
          }
        )
      ],
    );
  }
}
