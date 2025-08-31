import 'package:flutter/cupertino.dart';

class NavRule {
  final bool Function() condition;
  final Widget screen;
  final bool usePopUntil;
  final VoidCallback? onNavigate;

  NavRule(
      {required this.condition,
      required this.screen,
      required this.usePopUntil,
      this.onNavigate});
}
