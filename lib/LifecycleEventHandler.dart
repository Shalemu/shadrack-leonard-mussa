import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function() onResume;

  LifecycleEventHandler({required this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
