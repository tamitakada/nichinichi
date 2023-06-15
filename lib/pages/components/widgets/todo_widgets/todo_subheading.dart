import 'package:flutter/material.dart';

class TodoSubheading extends StatelessWidget {

  final String title;

  const TodoSubheading({ super.key, required this.title });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall,),
    );
  }
}
