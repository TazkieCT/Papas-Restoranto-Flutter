class Product {
  int id;
  String name;
  int price;
  String description;
  String image;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.image});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int,
      name: json['name'].toString(),
      price: json['price'] as int,
      description: json['description'].toString(),
      image: json['image'].toString());
}
