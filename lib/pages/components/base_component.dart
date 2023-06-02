import 'package:flutter/material.dart';
import 'package:nichinichi/global_widgets/half_border.dart';

class BaseComponent extends StatelessWidget {

  final String initialRoute;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;

  const BaseComponent({
    super.key,
    required this.initialRoute,
    this.onGenerateRoute
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: HalfBorder(),
          );
        }),
        ClipRect(
          child: Navigator(
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute
          )
        ),
      ]
    );
  }
}
