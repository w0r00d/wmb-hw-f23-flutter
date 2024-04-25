class Order {
  int id;
  int songId;
  int invoiceId;

  Order({
    required this.id,
    required this.songId,
    required this.invoiceId,
  });



    factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      songId: json['songId'] as int,
      invoiceId: json['invoiceId'] as int,
 
      
    );
  }
}