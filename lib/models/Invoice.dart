class Invoice {
  int id;
  int customerId;
  DateTime date;
  double total;
  String creditCard;

  Invoice({
    required this.id,
    required this.customerId,
    required this.date,
    required this.total,
    required this.creditCard,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as int,
      customerId: json['customerId'] as int,
      date: json['date'] as DateTime,
      total: json['total'] as double,
      creditCard: json['creditCard'] as String,
      
    );
  }
}
