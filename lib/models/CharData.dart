class CharData {
  final String brand;
  final int quantity;

  CharData({
    required this.brand,
    required this.quantity,
  });

  factory CharData.fromJson(Map<String, dynamic> json) {
    return CharData(
      brand: json['brand'],
      quantity: 0, // Default to 0 for grouped products
    );
  }
}
