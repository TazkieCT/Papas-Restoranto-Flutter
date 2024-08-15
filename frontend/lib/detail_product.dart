import 'package:flutter/material.dart';
import 'package:frontend/product_tab.dart';
import 'package:frontend/review_tab.dart';

class ProductDetailPage extends StatefulWidget {
  final int id;
  final String user;

  const ProductDetailPage({super.key, required this.id, required this.user});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Detail'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Product Info"),
              Tab(text: "Review"),
            ],
            labelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            ProductTab(
              id: widget.id,
              user: widget.user,
            ),
            ReviewTab(id: widget.id),
          ],
        ),
      ),
    );
  }
}
