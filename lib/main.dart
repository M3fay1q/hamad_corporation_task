import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hamad_corporation_task/logic/block/auth/auth_block.dart';
import 'package:hamad_corporation_task/core/utils/notification_helper.dart';
import 'package:hamad_corporation_task/presentation/screens/home_screen.dart';
import 'package:hamad_corporation_task/presentation/screens/login_screen.dart';
import 'package:hamad_corporation_task/presentation/screens/registration_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'data/repository/auth_repository.dart';
import 'data/model/user_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final ReceivePort receivePort = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  final userBox = await Hive.openBox<UserModel>('users');
  final storage = FlutterSecureStorage();

  String? isLoggedIn = await storage.read(key: 'username');
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await resetNotificationChannel();

  runApp(MyApp(userBox: userBox, isLoggedIn: isLoggedIn != null));
}

class MyApp extends StatelessWidget {
  final Box<UserModel> userBox;
  final bool isLoggedIn;

  const MyApp({super.key, required this.userBox, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository(userBox))),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? const HomeScreen() : LoginScreen(),
        routes: {
          '/login': (_) => LoginScreen(),
          '/register': (_) => const RegistrationScreen(),
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final storage = FlutterSecureStorage();

    String? startTimeString = await storage.read(key: 'sessionStartTime');
    if (startTimeString != null) {
      DateTime startTime = DateTime.parse(startTimeString);
      Duration elapsed = DateTime.now().difference(startTime);

      if (elapsed.inSeconds == 5) {
        await showAccountExpirationNotification();
      }
      if (elapsed.inSeconds == 10) {
        await showLogoutNotification();
        await storage.deleteAll();
        await storage.write(key: 'shouldLogout', value: 'true');
      }
    }
    return Future.value(true);
  });
}
