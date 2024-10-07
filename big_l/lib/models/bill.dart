class Bill{
  String id;
  String name;
  double amount;
  DateTime dueDate;
  bool isPaid;

  Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap(){
  return {
    'id': id,
    'name': name,
    'amount': amount,
    'dueDate': dueDate.toIso8601String(),
    'isPaid': isPaid,
    };
  }
  
  factory Bill.fromMap(Map<String, dynamic> map){
    return Bill(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      dueDate: DateTime.parse(map['dueDate']),
      isPaid: map['isPaid'],
    );
  }
}

