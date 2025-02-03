import 'package:flutter/foundation.dart';
import '../models/bill.dart';
import '../service/bill_database.dart';

class BillProvider with ChangeNotifier {
  List<Bill> _bills = [];
  List<Bill> get bills => _bills;

  BillProvider() {
    loadBills();
  }

  Future<void> loadBills() async {
    try {
      _bills = await BillDatabase.getAllBills();
      notifyListeners();
    } catch (e) {
      print('Error loading bills: $e');
    }
  }

  Future<void> addBill(Bill bill) async {
    try {
      await BillDatabase.saveBill(bill);
      await loadBills(); // Reload bills from database
    } catch (e) {
      print('Error adding bill: $e');
      rethrow;
    }
  }

  Future<void> updateBill(Bill bill) async {
    try {
      await BillDatabase.updateBill(bill);
      await loadBills();
    } catch (e) {
      print('Error updating bill: $e');
      rethrow;
    }
  }

  Future<void> deleteBill(Bill bill) async {
    try {
      await BillDatabase.deleteBill(bill);
      await loadBills();
    } catch (e) {
      print('Error deleting bill: $e');
      rethrow;
    }
  }

  void toggleBillStatus(int index) async {
    if (index >= 0 && index < _bills.length) {
      final bill = _bills[index];
      final updatedBill = Bill(
        name: bill.name,
        price: bill.price,
        dueDate: bill.dueDate,
        isPaid: !bill.isPaid,
      );
      await updateBill(updatedBill);
    }
  }

}