import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Review {
  final int id;
  final int foodId;
  final String name;
  final String review;

  Review(
      {required this.id,
      required this.foodId,
      required this.name,
      required this.review});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      foodId: json['foodId'] as int,
      name: json['name'].toString(),
      review: json['review'].toString(),
    );
  }
}

class ReviewTab extends StatefulWidget {
  final int id;

  const ReviewTab({super.key, required this.id});

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  // final List<Map<String, String>> reviews = [
  //   {
  //     'name': 'John Doe',
  //     'review': 'Great product! Really loved it. Highly recommended.',
  //   },
  //   {
  //     'name': 'Jane Smith',
  //     'review': 'Not bad, but could be better. The delivery was late.',
  //   },
  //   {
  //     'name': 'Alice Johnson',
  //     'review': 'Absolutely fantastic! Will buy again.',
  //   },
  // ];

  late Future<List<Review>> reviewList;

  Future<List<Review>> fetchReview() async {
    String url = "http://127.0.0.1:3000/product/get-review?id=${widget.id}";

    var response = await http.get(Uri.parse(url));

    var result = jsonDecode(response.body);
    // print(result);

    List<Review> productList = (result as List)
        .map((productJson) => Review.fromJson(productJson))
        .toList();

    return productList;
  }

  @override
  void initState() {
    super.initState();
    reviewList = fetchReview();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: reviewList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No reviews found'));
        } else {
          final reviews = snapshot.data!;
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review.review,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
