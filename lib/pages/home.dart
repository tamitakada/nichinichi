import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/utils/pair.dart';

import 'package:nichinichi/abstract_classes/error_management.dart';
import 'package:nichinichi/data_management/data_manager.dart';
import 'package:nichinichi/models/models.dart';

import 'package:nichinichi/global_widgets/logo_spinner.dart';

import 'components/components.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ErrorMixin implements OverlayManager {

  Future<TodoList?> _list = DataManager.getTodaysList();
  final ValueNotifier<Pair<Widget?, Color?>?> _overlayChild = ValueNotifier(null);

  void updateList() { setState(() { _list = DataManager.getTodaysList(); }); }

  // Overlay methods

  @override
  void closeOverlay() => _overlayChild.value = null;

  @override
  void updateOverlay(Widget? child, [Color? color]) {
    if (mounted) { _overlayChild.value = Pair(child, color); }
  }

  @override
  bool isOverlayOpen() => _overlayChild.value != null;

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
                } else {
                  showError(this, ErrorType.save);
                  return Container();
                }
              } else { return const Center(child: LogoSpinner()); }
            },
          )
        ),
        ValueListenableBuilder<Pair<Widget?, Color?>?>(
          valueListenable: _overlayChild,
          builder: (BuildContext context, Pair<Widget?, Color?>? overlayChild, _) {
            return overlayChild != null && overlayChild.a != null ? GestureDetector(
              onTap: closeOverlay,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: overlayChild.b ?? Colors.transparent,
                  ),
                  overlayChild.a!
                ],
              ),
            ) : Container();
          }
        )
      ],
    );
  }
}
