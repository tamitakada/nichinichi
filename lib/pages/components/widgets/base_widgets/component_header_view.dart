import 'package:flutter/material.dart';

class ComponentHeaderView extends StatelessWidget {

  final String title;
  final Widget? leadingAction;
  final List<Widget>? actions;

  const ComponentHeaderView({ super.key, required this.title, this.leadingAction, this.actions });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: (leadingAction != null)
              ? [leadingAction!, Text(title, style: Theme.of(context).textTheme.headlineMedium)]
              : [Text(title, style: Theme.of(context).textTheme.headlineMedium)]
          ),
          Row(children: actions ?? [])
        ]
      ),
    );
  }
}
