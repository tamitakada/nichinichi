import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'framed_button.dart';


class ErrorView extends StatelessWidget {

  final ErrorType type;
  final void Function() close;

  const ErrorView({ super.key, required this.type, required this.close });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Constants.grey
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Constants.red,
              size: 30,
            ),
            SizedBox(height: 10,),
            Text(
              "ERROR",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Constants.red),
            ),
            SizedBox(height: 20,),
            Text(
              Constants.errorToString(type),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 10,),
            Text(
              "Please try again later",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 30,),
            FramedButton(
              text: "OK",
              onTap: close,
            )
          ],
        ),
      ),
    );
  }
}
