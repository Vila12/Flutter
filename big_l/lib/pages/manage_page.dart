import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/bill.dart';
import '../providers/bill_provider.dart';
import 'home_page.dart';
// import '../service/bill_database.dart';

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BillProvider>(
      builder: (context, billProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          billProvider.loadBills();
        });
        return Scaffold(
          backgroundColor: const Color(0xFF1E1E1E),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Back Button
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF61bc84),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        iconSize: 20,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Manage bills",
                          style: GoogleFonts.notoSerif(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Display bills
                Expanded(
                  child: billProvider.bills.isEmpty
                      ? const Center(
                          child: Text(
                            'No bills to manage',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: billProvider.bills.length,
                          itemBuilder: (context, index) {
                            final bill = billProvider.bills[index];
                            return _buildBillCard(context, bill, index);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBillCard(BuildContext context, Bill bill, int index) {
    final billProvider = Provider.of<BillProvider>(context, listen: false);
    return Card(
      color: const Color(0xFF2A2A2A),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(bill.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text("Due: ${bill.dueDate}",
            style: const TextStyle(color: Colors.grey)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "\$${bill.price}",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF61bc84)),
              onPressed: () =>
                  _showEditDialog(context, bill, index, billProvider),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () =>
                  _showDeleteDialog(context, bill, index, billProvider),
            ),
          ],
        ),
      ),
    );
  }
}

void _showEditDialog(
  BuildContext context,
  Bill bill,
  int index,
  BillProvider provider,
) {
  final nameController = TextEditingController(text: bill.name);
  final priceController = TextEditingController(text: bill.price.toString());
  final dueDateController = TextEditingController(text: bill.dueDate);

  showDialog(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Edit Bill',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Bill Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF61bc84)),
                ),
              ),
            ),
            TextField(
              controller: priceController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF61bc84)),
                ),
              ),
            ),
            TextField(
              controller: dueDateController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Due Date',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF61bc84)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                final updatedBill = Bill(
                  name: nameController.text,
                  price: priceController.text,
                  dueDate: dueDateController.text,
                  isPaid: bill.isPaid,
                );
                // Use provider instead of direct database call
                await provider.updateBill(updatedBill);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bill updated successfully'),
                      backgroundColor: Color(0xFF61bc84),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating bill: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFF61bc84)),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showDeleteDialog(
  BuildContext context,
  Bill bill,
  int index,
  BillProvider provider,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF2A2A2A),
      title: const Text(
        'Delete Bill',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        'Are you sure you want to delete ${bill.name}?',
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () async {
            try {
              // Use provider instead of direct database call
              await provider.deleteBill(bill);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bill deleted successfully'),
                    backgroundColor: Color(0xFF61bc84),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting bill: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
}
