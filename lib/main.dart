// ignore_for_file: avoid_print, library_prefixes

import 'dart:async';

import 'package:flutter/material.dart';
import '/src/utils/notification_service.dart';
import '/src/di/service_locator.dart';
import 'app.dart';
import 'src/data/storage_data/storage_data.dart';

Future<void> main() async {
  setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  final Storage store = serviceLocator<Storage>();
  bool isAuthenticated = await store.isAuthenticated();

  runApp(Jojolo(isAuth: isAuthenticated));
}
