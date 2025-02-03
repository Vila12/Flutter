import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/bill.dart';

class BillDatabase {
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/bills.json';
  }

  static Future<List<Bill>> getAllBills() async {
    try {
      final file = File(await _getFilePath());
      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final List<dynamic> data = json.decode(jsonData);
        return data.map((item) => Bill.fromMap(item)).toList();
      } else {
        // Create the file if it doesn't exist
        await file.create(recursive: true);
        await file.writeAsString('[]');
        return [];
      }
    } catch (e) {
      print('Error reading bills: $e');
      return [];
    }
  }

  static Future<void> saveBill(Bill bill) async {
    try {
      final file = File(await _getFilePath());
      List<Bill> allBills = await getAllBills();
      allBills.add(bill);
      final jsonData = json.encode(allBills.map((b) => b.toMap()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      print('Error saving bill: $e');
      rethrow; // Add this line
    }
  }

  static Future<void> updateBill(Bill bill) async {
    try {
      final file = File(await _getFilePath());
      List<Bill> allBills = await getAllBills();
      final index = allBills.indexWhere((b) => b.name == bill.name);
      if (index != -1) {
        allBills[index] = bill;
        final jsonData = json.encode(allBills.map((b) => b.toMap()).toList());
        await file.writeAsString(jsonData);
      }
    } catch (e) {
      print('Error updating bill: $e');
    }
  }

  static Future<void> deleteBill(Bill bill) async {
    try {
      final file = File(await _getFilePath());
      List<Bill> allBills = await getAllBills();
      final updatedBills = allBills.where((b) => b.name != bill.name).toList();
      final jsonData = json.encode(updatedBills.map((b) => b.toMap()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      print('Error deleting bill: $e');
    }
  }
}
