// bill_provider.dart
import 'package:flutter/foundation.dart';
import 'package:big_l/models/bill.dart';

class BillProvider extends ChangeNotifier {
  final List<Bill> _bills = [];

  List<Bill> get bills => _bills;

  void addBill(Bill bill) {
    _bills.add(bill);
    notifyListeners();
  }

  void toggleBillStatus(int index) {
    _bills[index].isPaid = !_bills[index].isPaid;
    notifyListeners();
  }

  void removeBill(int index) {
    _bills.removeAt(index);
    notifyListeners();
  }
}