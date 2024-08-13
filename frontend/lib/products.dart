import 'package:flutter/material.dart';

class Product {
  final String imageUrl;
  final String name;
  final double price;

  Product({required this.imageUrl, required this.name, required this.price});
}

class ProductListPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      imageUrl: 'https://via.placeholder.com/150',
      name: 'Product 1',
      price: 29.99,
    ),
    Product(
      imageUrl: 'https://via.placeholder.com/150',
      name: 'Product 2',
      price: 19.99,
    ),
    Product(
      imageUrl: 'https://via.placeholder.com/150',
      name: 'Product 3',
      price: 39.99,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: Image.network(
              product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
