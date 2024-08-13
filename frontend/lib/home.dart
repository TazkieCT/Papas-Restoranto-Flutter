import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/login.dart';
import 'package:frontend/products.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.isDarkTheme, required this.title});

  final String title;

  bool isDarkTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _product() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[600],
          title: Text(widget.title),
          actions: [
            TextButton(
                onPressed: _product,
                child: const Text(
                  "Products",
                  style: TextStyle(color: Colors.white),
                )),
            // TextButton( //LOGOUT DIPINDAH KE POP UP MENU BUTTON
            //     onPressed: _logout,
            //     child: const Text(
            //       "Logout",
            //       style: TextStyle(color: Colors.white),
            //     )),
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.star),
                            Text('Change Theme'),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            widget.isDarkTheme = !widget.isDarkTheme;
                          });
                        },
                      ),
                      PopupMenuItem(
                        onTap: _logout,
                        child: const Row(
                          children: [
                            Icon(Icons.logout),
                            Text('Log Out'),
                          ],
                        ),
                      )
                    ])
          ],
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageCarousel(),
            SizedBox(height: 20),
            Text(
              'History of Papa’s Restoranto',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Founding and Early Years',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Papa\'s Restoranto was founded in 1985 by ZK, a visionary entrepreneur with a deep appreciation for authentic Italian cuisine. Zachary, inspired by his travels through Italy and his passion for cooking, sought to bring a taste of Italy to his new community.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'He opened Papa\'s Restoranto in a charming, historic building in Wakanda\'s vibrant neighborhood. With a commitment to quality and authenticity, the restaurant quickly gained a reputation for its delectable Italian dishes, warm atmosphere, and exceptional service.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  ImageCarouselState createState() => ImageCarouselState();
}

class ImageCarouselState extends State<ImageCarousel> {
  int currentIndex = 0;
  List<String> imagePaths = [
    'images/1.png',
    'images/2.png',
    'images/3.png',
  ];
  Timer? timer;
  PageController pageController = PageController(initialPage: 1000);

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % imagePaths.length;
        pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      });
    });
  }

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 200,
        child: PageView.builder(
          controller: pageController,
          itemCount: imagePaths.length * 2000,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index % imagePaths.length;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return Image.asset(
              imagePaths[index % imagePaths.length],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            imagePaths.length, (index) => buildIndicatorButton(index)),
      )
    ]);
  }

  Widget buildIndicatorButton(int index) {
    return GestureDetector(
      onTap: () {
        goToPage(index + (imagePaths.length * 1000));
      },
      child: Container(
        height: 10,
        width: 10,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentIndex == index ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
