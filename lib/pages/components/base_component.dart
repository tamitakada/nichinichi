import 'package:flutter/material.dart';
import 'package:nichinichi/global_widgets/half_border.dart';


class BaseComponent extends StatelessWidget {

  final Widget child;

  const BaseComponent({
    super.key,
    required this.child
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
          ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
            child: child
          ),
        ]
    );
  }
}

class BaseNavigatorComponent extends StatelessWidget {

  final String initialRoute;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;

  const BaseNavigatorComponent({
    super.key,
    required this.initialRoute,
    this.onGenerateRoute
  });

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      child: Navigator(
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute
      )
    );
  }
}
