class Product {
  String brand;
  String condition;
  String model;
  String sellingPrice;
  ProductStatus status;
  String serialNumber;
  String variant;

  Product({
    required this.brand,
    required this.model,
    required this.variant,
    required this.condition,
    required this.sellingPrice,
    required this.serialNumber,
    required this.status,
  });

  // Named constructor for creating from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      brand: json['brand'] ?? 'Unknown Brand',
      condition: json['condition'] ?? 'Unknown Condition',
      model: json['model'] ?? 'Unknown Model',
      variant: json['variant'] ?? 'Unknown Variant',
      sellingPrice: (json['sellingPrice'] ?? 0.0),
      serialNumber: json['serialNumber'] ?? 'Unknown Serial',
      status: ProductStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => ProductStatus.EXPIRED,  // Default to EXPIRED if status is not available
      ),
    );
  }

  // Convert to JSON for API or storage
  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'condition': condition,
      'model': model,
      'variant': variant,
      'sellingPrice': sellingPrice,
      'serialNumber': serialNumber,
      'status': status.name,
    };
  }
}
enum ProductStatus {
  BILLED('BILLED'),
  SOLD('SOLD'),
  EXPIRED('EXPIRED');

  final String name;

  const ProductStatus(this.name);
}