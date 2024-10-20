class Bill{
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

  Map<String, dynamic> toMap(){
  return {
    'name': name,
    'amount': price,
    'dueDate': dueDate,
    'isPaid': isPaid,
    };
  }

}

