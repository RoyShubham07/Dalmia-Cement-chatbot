String dateFormat(DateTime today) {
  return "${today.year.toString()}/${today.month.toString().padLeft(2, '0')}/${today.day.toString().padLeft(2, '0')}";
}

class Order {
  final int id;
  final DateTime created_at;
  final int quantity;
  final DateTime expected_delivery;
  final double amount;
  Order({
    required this.id,
    required this.created_at,
    required this.quantity,
    required this.expected_delivery,
    required this.amount,
  });

  Order copyWith({
    int? id,
    DateTime? created_at,
    int? quantity,
    DateTime? expected_delivery,
    double? amount,
  }) {
    return Order(
      id: id ?? this.id,
      created_at: created_at ?? this.created_at,
      quantity: quantity ?? this.quantity,
      expected_delivery: expected_delivery ?? this.expected_delivery,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': created_at,
      'quantity': quantity,
      'expected_delivery': expected_delivery.millisecondsSinceEpoch,
      'amount': amount,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      created_at: DateTime.parse(map['created_at']),
      quantity: map['quantity'] as int,
      expected_delivery: DateTime.parse(map['expected_delivery']),
      amount: map['amount'] * 1.0,
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, created_at: ${dateFormat(created_at)}, quantity: $quantity, expected_delivery: ${dateFormat(expected_delivery)}, amount: ₹$amount)';
  }

  String toStatusText() {
    return 'Your order with ID $id was placed on ${dateFormat(created_at)}, totaling ₹$amount.';
  }

  String toDeliveryDetails() {
    if (expected_delivery.isBefore(DateTime.now())) {
      return 'Your order with ID $id has been successfully delivered as scheduled on ${dateFormat(expected_delivery)}.';
    }
    return 'Your order with ID $id is expected to be delivered on ${dateFormat(expected_delivery)}.';
  }

  String toOrderHistory() {
    if (expected_delivery.isBefore(DateTime.now())) {
      return 'Your order with ID $id was placed on ${dateFormat(created_at)}, totaling ₹$amount, and has been successfully delivered as scheduled on ${dateFormat(expected_delivery)}.';
    }
    return 'Your order with ID $id was placed on ${dateFormat(created_at)}, totaling ₹$amount, and is expected to be delivered on ${dateFormat(expected_delivery)}.';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.created_at == created_at &&
        other.quantity == quantity &&
        other.expected_delivery == expected_delivery &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        created_at.hashCode ^
        quantity.hashCode ^
        expected_delivery.hashCode ^
        amount.hashCode;
  }
}
