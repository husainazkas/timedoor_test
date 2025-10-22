import 'dart:async';

import 'package:flutter/material.dart';

import 'injector.dart';
import 'presentation/app.dart';
import 'storage_config.dart';

void main() {
  // Better use [runZonedGuarded] if we collect crachlytics information
  runZoned(() async {
    await initStorage();
    initDependencies();

    runApp(const App());
  });
}
