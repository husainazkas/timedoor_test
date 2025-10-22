import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'presentation/app.dart';

void main() {
  // Better use [runZonedGuarded] if we collect crachlytics information
  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    runApp(const App());
  });
}
