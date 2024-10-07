// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import '../models/bill.dart';

class BillProvider with ChangeNotifier{
  List<Bill> _bills = [];

  List<Bill> get bills => _bills;

  void addBill(Bill bill){
    _bills.add(bill);
    notifyListeners();
  }

  void deleteBill(String id){
    _bills.removeWhere((bill)=>bill.id == id);
    notifyListeners();
  }

  void markAsPaid(String id){
    final bill = _bills.firstWhere((bill)=>bill.id == id);
    bill.isPaid = true;
    notifyListeners();
  }

  void markAsUnpaid(String id){
    final bill = _bills.firstWhere((bill)=> bill.id == id);
    bill.isPaid = false;
    notifyListeners();
  }

  List<Bill> get paidBills => _bills.where((bill)=>bill.isPaid).toList();

  List<Bill> get unpaidBills => _bills.where((bill) => !bill.isPaid).toList();
  
}