import 'dart:convert' show base64Decode, base64Encode;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'infrastructure/bookings/data_source/i_bookings_data_source.dart';
import 'infrastructure/theme/data_source/i_theme_data_source.dart';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.unlocked_this_device,
  ),
);

Future<void> initStorage() async {
  await Hive.initFlutter();

  final savedKey = await _storage.read(key: 'key');
  final secureKey = savedKey != null
      ? base64Decode(savedKey)
      : Hive.generateSecureKey();
  final cipher = HiveAesCipher(secureKey);

  if (savedKey == null) {
    await _storage.write(key: 'key', value: base64Encode(secureKey));
  }

  await Hive.openBox(IThemeDataSource.boxName, encryptionCipher: cipher);
  await Hive.openLazyBox(IBookingsDataSource.boxName, encryptionCipher: cipher);
}
