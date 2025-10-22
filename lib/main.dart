import 'dart:async';

import 'package:flutter/material.dart';

import 'presentation/app.dart';

void main() {
  // Better use [runZonedGuarded] if we collect crachlytics information
  runZoned(() {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(const App());
  });
}
