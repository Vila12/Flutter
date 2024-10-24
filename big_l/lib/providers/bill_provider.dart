// bill_provider.dart
import 'package:flutter/foundation.dart';
import 'package:big_l/models/bill.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';
import '../main.dart';  // Import the initialized notification plugin

class BillProvider extends ChangeNotifier {
  final List<Bill> _bills = [];

  List<Bill> get bills => _bills;

  // Add a new bill and schedule notification
  void addBill(Bill bill) {
    _bills.add(bill);
    notifyListeners();
    
    // Schedule the notification one day before the due date
    _scheduleNotification(bill);
  }

  void toggleBillStatus(int index) {
    _bills[index].isPaid = !_bills[index].isPaid;
    notifyListeners();
  }

  void removeBill(int index) {
    _cancelNotification(_bills[index]);  // Cancel notification if the bill is removed
    _bills.removeAt(index);
    notifyListeners();
  }

  void updateBill(int index, Bill newBill) {
    _cancelNotification(_bills[index]);  // Cancel old notification
    _bills[index] = newBill;
    _scheduleNotification(newBill);      // Schedule new notification
    notifyListeners();
  }

  // Schedule notification
  void _scheduleNotification(Bill bill) {
    final dueDate = DateTime.parse(bill.dueDate);
    final notificationTime = dueDate.subtract(const Duration(days: 1));  // One day before due date

    flutterLocalNotificationsPlugin.zonedSchedule(
      _bills.length,  // Use the bill's index or a unique id
      'Upcoming Bill Due',
      '${bill.name} is due tomorrow!',
      tz.TZDateTime.from(notificationTime, local),  // Schedule time in local timezone
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',  // Replace with your channel id
          'Bill Notifications',  // Replace with your channel name
          channelDescription: 'Reminder for upcoming bill due date',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,  // Schedule based on exact time
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancel notification when bill is removed or updated
  void _cancelNotification(Bill bill) {
    flutterLocalNotificationsPlugin.cancel(_bills.indexOf(bill));  // Cancel notification by id
  }
}
