import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hamad_corporation_task/presentation/screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    startAndCancelTimer();
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _startSessionTimers() async {
    await Workmanager().cancelAll();
    await storage.write(
        key: 'sessionStartTime', value: DateTime.now().toString());
    Workmanager().registerOneOffTask(
      "1",
      "sessionMonitorTask",
      initialDelay: const Duration(minutes: 1),
    );
    Workmanager().registerOneOffTask(
      "2",
      "sessionMonitorTask",
      initialDelay: const Duration(minutes: 2),
    );
  }

  void startAndCancelTimer() {
    timer?.cancel();
    _startSessionTimers();
    timer = Timer(const Duration(seconds: 122), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when disposing the widget
    Workmanager().cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Clear login status
              await storage.delete(key: 'username');
              await storage.delete(key: 'password');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
              // Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final username = await storage.read(key: 'username');
            // Reset timer when renewing account
            startAndCancelTimer();
          },
          child: const Text('Renew Account'),
        ),
      ),
    );
  }
}
