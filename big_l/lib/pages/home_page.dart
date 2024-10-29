// home_page.dart
import 'package:big_l/pages/manage_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import 'new_bill_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use watch() to listen to changes
    final billProvider = Provider.of<BillProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      billProvider.loadBills();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Big L",
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerif(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.white,
                thickness: 0.5,
              ),
            ),

            // Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    context: context,
                    label: "Manage",
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManagePage()),
                    ),
                  ),
                  _buildButton(
                    context: context,
                    label: "Add new",
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewPage()),
                    ),
                  ),
                  _buildButton(
                    context: context,
                    label: "Test",
                    onTap: () {
                      Provider.of<BillProvider>(context, listen: false)
                          .triggerTestNotification();
                    },
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Divider(
                color: Colors.white,
                thickness: 0.5,
              ),
            ),

            // Bills List Section
            Expanded(
              child: billProvider.bills.isEmpty
                  ? const Center(
                      child: Text(
                        'No bills yet',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: billProvider.bills.length,
                      itemBuilder: (context, index) {
                        final bill = billProvider.bills[index];
                        return Card(
                          color: const Color(0xFF2A2A2A),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(
                              bill.name,
                              style: TextStyle(
                                color: Colors.white,
                                decoration: bill.isPaid
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(
                              "Due: ${bill.dueDate}",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "€${bill.price}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Checkbox(
                                  value: bill.isPaid,
                                  onChanged: (bool? value) {
                                    billProvider.toggleBillStatus(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF61bc84),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
