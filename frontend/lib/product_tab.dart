import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'].toString(),
      price: (json['price'] as num).toDouble(),
      description: json['description'].toString(),
      image: json['image'].toString(),
    );
  }
}

class ProductTab extends StatefulWidget {
  final int id;
  final String user;

  const ProductTab({super.key, required this.id, required this.user});

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  late Future<Product> product;
  final TextEditingController _reviewController = TextEditingController();

  Future<Product> fetchProduct() async {
    String url = "http://127.0.0.1:3000/product/get?id=${widget.id}";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body) as List<dynamic>;
        var productJson = result.firstWhere(
          (p) => (p['id'] as int) == widget.id,
          orElse: () => {},
        );

        if (productJson.isNotEmpty) {
          return Product.fromJson(productJson as Map<String, dynamic>);
        } else {
          throw Exception('Product not found');
        }
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    product = fetchProduct();
  }

  void _submitReview() async {
    String review = _reviewController.text;
    // print('Submitted review: $review');
    String url = "http://127.0.0.1:3000/product/review-food";
    String json = jsonEncode({
      "id": widget.id,
      "review": review,
      "name": widget.user,
    });

    // final resp =
    await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: json);

    _reviewController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: product,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No product found'));
        } else {
          final product = snapshot.data!;
          return Column(
            children: [
              Image.network(product.image),
              Text(product.name, style: Theme.of(context).textTheme.titleLarge),
              Text('\$${product.price}',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(product.description,
                  style: Theme.of(context).textTheme.titleSmall),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _reviewController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter your review',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submitReview,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
