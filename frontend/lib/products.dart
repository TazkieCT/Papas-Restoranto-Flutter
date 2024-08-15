import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/add_product.dart';
import 'package:frontend/detail_product.dart';
import 'package:frontend/update_price.dart';

import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String image;
  final String name;
  final double price;

  Product(
      {required this.id,
      required this.image,
      required this.name,
      required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      image: json['image'].toString(),
      name: json['name'].toString(),
      price: (json['price'] as num).toDouble(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key, required this.user});

  final String user;

  @override
  // ignore: library_private_types_in_public_api
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> productList;

  Future<List<Product>> fetchProducts() async {
    String url = "http://127.0.0.1:3000/product/get-all";

    var response = await http.get(Uri.parse(url));

    var result = jsonDecode(response.body);
    // print(result);

    List<Product> productList = (result as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList();

    return productList;
  }

  Future _onDelete(int id) async {
    String url = "http://127.0.0.1:3000/product/delete-food";

    var resp = await http.delete(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'id': id}));

    if (resp.statusCode == 200) {
      // print("Product deleted successfully");
      setState(() {
        productList = fetchProducts();
      });
    }
  }

  Future _onUpdate(int id) async {
    // BUAT PINDAH HALAMAN UNTUK UBAH HARGA PASSING id
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdatePricePage(id: id)),
    );
  }

  @override
  void initState() {
    super.initState();
    productList = fetchProducts();
  }

  void openAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddProductPage(
                user: widget.user,
              )),
    );
  }

  void openProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailPage(
                id: product.id,
                user: widget.user,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: FutureBuilder<List<Product>>(
          future: productList,
          builder: (context, snapshot) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () => openProductDetail(product),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        product.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: FittedBox(
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _onUpdate(product.id),
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: const Text('Update'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _onDelete(product.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => openAddProduct(context),
      ),
    );
  }
}
