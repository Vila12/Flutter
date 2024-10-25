import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/bill_provider.dart';
import 'pages/home_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as timezone;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Initialization settings for Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize flutter_local_notifications
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      // Handle notification tap
      final String? payload = notificationResponse.payload;
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    },
  );

  // Request notification permissions for Android 13 and above
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize timezone
    tz.initializeTimeZones();
    final String timeZoneName = timezone.local.name;
    timezone.setLocalLocation(timezone.getLocation(timeZoneName));

    // Initialize notifications
    await initNotifications();

    // Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id',
      'Bill Notifications',
      description: 'Reminder for upcoming bill due date',
      importance: Importance.max,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error during initialization: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BillProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Big L',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF61bc84),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        ),
        home: const HomePage(),
      ),
    );
  }
}