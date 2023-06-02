import 'package:flutter/material.dart';

class FramedButton extends StatefulWidget {

  final String text;
  final Color color;
  final void Function() onTap;

  const FramedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = Colors.white
  });

  @override
  State<FramedButton> createState() => _FramedButtonState();
}

class _FramedButtonState extends State<FramedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.color,
            width: 2
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          widget.text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
