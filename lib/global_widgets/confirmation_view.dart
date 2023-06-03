import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/global_widgets/framed_button.dart';

class ConfirmationView extends StatelessWidget {

  final String message;
  final void Function() onConfirm;
  final void Function()? onCancel;

  const ConfirmationView({
    super.key, required this.message, required this.onConfirm, this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Constants.grey
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Constants.yellow,
                    size: 30,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ARE YOU SURE?",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Constants.yellow),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FramedButton(
                  text: "CANCEL",
                  onTap: () {
                    if (onCancel != null) onCancel!();
                  },
                ),
                const SizedBox(width: 20),
                FramedButton(
                  text: "OK",
                  onTap: onConfirm,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
