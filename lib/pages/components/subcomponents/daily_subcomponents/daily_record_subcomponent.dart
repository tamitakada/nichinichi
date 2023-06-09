import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';

import 'package:nichinichi/data_management/data_manager.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/utils/error_management.dart';

import 'package:nichinichi/pages/components/widgets/base_widgets/component_header_view.dart';
import 'package:nichinichi/pages/components/widgets/todo_widgets/static_widgets.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/utils/daily_stats_mixin.dart';
import 'package:nichinichi/utils/confirmation_mixin.dart';

class DailyRecordSubcomponent extends StatefulWidget {

  final TodoList list;
  final Daily daily;
  final OverlayManager manager;

  const DailyRecordSubcomponent({
    super.key, required this.list, required this.daily, required this.manager
  });

  @override
  State<DailyRecordSubcomponent> createState() => _DailyRecordSubcomponentState();
}

class _DailyRecordSubcomponentState extends State<DailyRecordSubcomponent> with DailyStats, ConfirmationMixin, ErrorMixin  {

  void _changeSingleCompletion(Item item, bool toComplete) {
    showConfirmation(
      "You're editing a past to do list record.",
      widget.manager,
      () => DataManager.changeSingleCompletion(widget.list, item, toComplete).then(
        (success) {
          if (success) { setState(() {}); }
          else { showError(widget.manager, ErrorType.save); }
        }
      )
    );
  }

  void _changeCompletionStatus(Item item, bool toComplete) {
    showConfirmation(
      "You're editing a past to do list record.",
      widget.manager,
      () => DataManager.changeDailyCompletion(widget.list, item, toComplete).then(
        (success) {
          if (success) { setState(() {}); }
          else { showError(widget.manager, ErrorType.save); }
        }
      )
    );
  }

  List<Widget> _buildCompleteItems() {
    List<Item> sortedCompleteItems = getSortedCompleteDailyItems(widget.list, widget.daily);
    List<Widget> completeItems = [];
    for (int i = 0; i < sortedCompleteItems.length; i++) {
      Item item = sortedCompleteItems[i];
      completeItems.add(
        CompleteItemView(
          item: item,
          onTap: () => _changeCompletionStatus(item, false)
        )
      );
    }
    return completeItems;
  }

  List<Widget> _buildIncompleteItems() {
    List<Item> sortedIncompleteItems = getSortedIncompleteDailyItems(widget.list, widget.daily);
    List<Widget> incompleteItems = [];
    for (int i = 0; i < sortedIncompleteItems.length; i++) {
      Item item = sortedIncompleteItems[i];
      incompleteItems.add(
        IncompleteItemView(
          item: item,
          onTap: () => _changeCompletionStatus(item, true)
        )
      );
    }
    return incompleteItems;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ComponentHeaderView(
          title: "DAILY RECORD",
          leadingAction: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.arrow_back_ios, color: Colors.white, size: 18,
            )
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "COMPLETE",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildCompleteItems()
                  )
                ],
              )
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "INCOMPLETE",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildIncompleteItems()
                  )
                ],
              )
            )
          ],
        )
      ],
    );
  }
}
