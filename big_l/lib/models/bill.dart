class Bill {
  final String name;
  final String price;
  final String dueDate;
  bool isPaid;

  Bill({
    required this.name,
    required this.price,
    required this.dueDate,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'dueDate': dueDate,
      'isPaid': isPaid,
    };
  }

  static Bill fromMap(Map<String, dynamic> map) {
    return Bill(
      name: map['name'],
      price: map['price'].toString(),
      dueDate: map['dueDate'],
      isPaid: map['isPaid'] ?? false,
    );
  }
}