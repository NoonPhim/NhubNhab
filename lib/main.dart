import 'dart:convert'; // สำหรับการอ่าน JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // สำหรับ rootBundle เพื่อโหลดไฟล์ assets
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BookStoreApp());
}

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ร้านขายหนังสือ',
      theme: ThemeData(
        textTheme: GoogleFonts.fredokaTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B705C)),
        scaffoldBackgroundColor: const Color(0xFFF8F3E9),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xff858c71),
          titleTextStyle: GoogleFonts.fredoka(
            fontSize: 22,
            color: const Color(0xFFF8F3E9),
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://i.pinimg.com/564x/5a/96/89/5a9689bd06a2597645da58af22a5e512.jpg',
              width: 300,
              height: 200,
            ),
            const SizedBox(height: 30),
            Text(
              'Nhub Nhab Book',
              style: GoogleFonts.fredoka(
                fontSize: 32,
                color: const Color(0xff777c68),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookCategoryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff9ba970),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('ปริ๊งงง'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookCategoryPage extends StatefulWidget {
  const BookCategoryPage({super.key});

  @override
  _BookCategoryPageState createState() => _BookCategoryPageState();
}

class _BookCategoryPageState extends State<BookCategoryPage> {
  final List<String> allCategories = [
    'แฟนตาซี',
    'ดรามา',
    'โรแมนติก',
    'Y/N',
    'ตลก'
  ];
  final List<String> selectedCategories = [];
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<String> filteredCategories = allCategories
        .where((category) => category.contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกหมวดหมู่'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'ค้นหาหมวดหมู่',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return CheckboxListTile(
                    title: Text(category,
                        style: GoogleFonts.fredoka(fontSize: 18)),
                    value: selectedCategories.contains(category),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedCategories.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(
                        selectedCategories: selectedCategories,
                      ),
                    ),
                  );
                }
              },
              child: const Text('ไปที่หมวดหมู่ที่เลือก'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductPage extends StatefulWidget {
  final List<String> selectedCategories;

  const ProductPage({super.key, required this.selectedCategories});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final String response = await rootBundle.loadString('assets/product.json');
    final data = await json.decode(response);
    setState(() {
      products = data
          .where((product) =>
              widget.selectedCategories.contains(product['category']))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สินค้าตามหมวดหมู่'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              // นำทางไปที่หน้ารายละเอียดสินค้า
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product['imageUrl'],
                    height: 200, // ลดความสูงลงเล็กน้อยเพื่อป้องกันการล้น
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: GoogleFonts.fredoka(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Price: ${product['price']}',
                          style: GoogleFonts.fredoka(
                              fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// หน้าแสดงรายละเอียดสินค้า
class ProductDetailPage extends StatelessWidget {
  final dynamic product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product['imageUrl'],
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                product['name'],
                style: GoogleFonts.fredoka(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Price: ${product['price']}',
                style:
                    GoogleFonts.fredoka(fontSize: 20, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              Text(
                'Description: ${product['description']}',
                style: GoogleFonts.fredoka(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
