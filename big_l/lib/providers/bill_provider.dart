import 'package:flutter/foundation.dart';
import 'package:big_l/models/bill.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '../main.dart';

class BillProvider extends ChangeNotifier {
  final List<Bill> _bills = [];

  List<Bill> get bills => List.unmodifiable(_bills); // Return unmodifiable list for safety

  // Add a new bill and schedule notification
  void addBill(Bill bill) {
    _bills.add(bill);
    _scheduleNotification(bill);
    print('Bill added: ${bill.name}'); // Debug print
    notifyListeners();
  }

  void toggleBillStatus(int index) {
    if (index >= 0 && index < _bills.length) {
      _bills[index].isPaid = !_bills[index].isPaid;
      print('Bill status toggled: ${_bills[index].name}'); // Debug print
      notifyListeners();
    }
  }

  void removeBill(int index) {
    if (index >= 0 && index < _bills.length) {
      _cancelNotification(_bills[index]);
      final removedBill = _bills.removeAt(index);
      print('Bill removed: ${removedBill.name}'); // Debug print
      notifyListeners();
    }
  }

  void updateBill(int index, Bill newBill) {
    if (index >= 0 && index < _bills.length) {
      try {
        print('Updating bill at index $index'); // Debug print
        print('Old bill: ${_bills[index].name}'); // Debug print
        
        _cancelNotification(_bills[index]);
        _bills[index] = newBill;
        _scheduleNotification(newBill);
        
        print('New bill: ${newBill.name}'); // Debug print
        print('Current bills: ${_bills.map((b) => b.name).toList()}'); // Debug print
        
        notifyListeners();
      } catch (e) {
        print('Error updating bill: $e'); // Debug print
      }
    }
  }

  // Schedule notification with error handling
  void _scheduleNotification(Bill bill) {
    try {
      final dueDate = DateFormat('dd-MM-yyyy').parse(bill.dueDate);
      final notificationTime = dueDate.subtract(const Duration(days: 1));
      final billIndex = _bills.indexOf(bill);

      if (billIndex == -1) {
        print('Warning: Bill not found in list when scheduling notification'); // Debug print
        return;
      }

      flutterLocalNotificationsPlugin.zonedSchedule(
        billIndex,
        'Upcoming Bill Due',
        '${bill.name} is due tomorrow!',
        tz.TZDateTime.from(notificationTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'Bill Notifications',
            channelDescription: 'Reminder for upcoming bill due date',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('Notification scheduled for ${bill.name}'); // Debug print
    } catch (e) {
      print('Error scheduling notification: $e'); // Debug print
    }
  }

  void _cancelNotification(Bill bill) {
    try {
      final billIndex = _bills.indexOf(bill);
      if (billIndex != -1) {
        flutterLocalNotificationsPlugin.cancel(billIndex);
        print('Notification cancelled for ${bill.name}'); // Debug print
      }
    } catch (e) {
      print('Error cancelling notification: $e'); // Debug print
    }
  }
}