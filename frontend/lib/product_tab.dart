import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String image;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.image});

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

  const ProductTab({Key? key, required this.id}) : super(key: key);

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  late Future<Product> product;

  // Future<Product> fetchProduct() async {
  //   String url = "http://127.0.0.1:3000/product/get?id=${widget.id}";

  //   try {
  //     var response = await http.get(Uri.parse(url));
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body);
  //       print(
  //           "bawahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
  //       print(result);
  //       return Product.fromJson(result);
  //     } else {
  //       throw Exception('Failed to load product');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load product: $e');
  //   }
  // }
Future<Product> fetchProduct() async {
  String url = "http://127.0.0.1:3000/product/get?id=${widget.id}";

  try {
    var response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body) as List<dynamic>;
      // Find the product with the matching ID
      var productJson = result.firstWhere(
        (p) => (p['id'] as int) == widget.id,
        orElse: () => {} // Provide a default empty map if not found
      );
      
      // Check if productJson is not empty
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
              Text(product.name, style: Theme.of(context).textTheme.headline6),
              Text('\$${product.price}',
                  style: Theme.of(context).textTheme.subtitle1),
            ],
          );
        }
      },
    );
  }
}
