class Warranty {
  String id;
  String reason;
  String reasonDescription;
  List<String> images;
  String createdAt;

  Warranty(
      {required this.id,
      required this.reason,
      required this.reasonDescription,
      required this.images,
      required this.createdAt});

  factory Warranty.fromJson(Map<String, dynamic> json) => Warranty(
        reason: json['reason'],
        reasonDescription: json['reasonDescription'],
        images: json['images'],
        createdAt: json['createdAt'],
        id: json['id'],
      );
  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'reasonDescription': reasonDescription,
      'images': images,
      'createdAt': createdAt,
      'id' : id
    };
  }

  // Named constructor for creating from a Map (optional)
  factory Warranty.fromMap(Map<String, dynamic> map) => Warranty.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}
