import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart'; // Ensure the path is correct
import '../pages/home_page.dart'; // Import the HomePage from home_page.dart

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BillProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big L',
      home: HomePage(), // The HomePage is now linked from home_page.dart
    );
  }
}
