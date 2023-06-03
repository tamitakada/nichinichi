import 'package:flutter/material.dart';
import 'package:nichinichi/global_widgets/framed_button.dart';


class EmptyDailySubcomponent extends StatelessWidget {

  const EmptyDailySubcomponent({ super.key });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("NO DAILY TASKS", style: Theme.of(context).textTheme.headlineMedium,),
        const SizedBox(height: 20),
        Text(
          "Add new daily tasks to track longterm habits",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white54
          )
        ),
        const SizedBox(height: 20),
        FramedButton(
          text: "New Daily",
          onTap: () => Navigator.of(context).pushNamed('daily/edit')
        )
      ],
    );
  }
}
