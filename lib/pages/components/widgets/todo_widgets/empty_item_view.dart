import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';

class EmptyItemView extends StatelessWidget {

  const EmptyItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constants.grey,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("NO TASKS", style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tap the ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white54
                ),
              ),
              const Icon(
                Icons.add,
                color: Colors.white54,
                size: 12,
              ),
              Text(
                " to add tasks",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white54
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
