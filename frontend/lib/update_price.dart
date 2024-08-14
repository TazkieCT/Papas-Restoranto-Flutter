import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePricePage extends StatefulWidget {
  final int id;

  const UpdatePricePage({Key? key, required this.id}) : super(key: key);

  @override
  _UpdatePricePageState createState() => _UpdatePricePageState();
}

class _UpdatePricePageState extends State<UpdatePricePage> {
  final _priceController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _updatePrice() async {
    final newPrice = _priceController.text;
    if (newPrice.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a price';
      });
      return;
    }
    String url = "http://127.0.0.1:3000/product/update-food";

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': widget.id,
        'price': double.parse(newPrice),
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = 'Failed to update price';
      });
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Price'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'New Price',
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updatePrice,
                    child: const Text('Update Price'),
                  ),
          ],
        ),
      ),
    );
  }
}
