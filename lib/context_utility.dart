import 'package:flutter/cupertino.dart';

class ContextUtility {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static NavigatorState? navigatorState = navigatorKey.currentState;
  static BuildContext? context = navigatorState?.overlay?.context;
}
