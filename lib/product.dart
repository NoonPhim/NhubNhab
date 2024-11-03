import 'dart:convert'; // สำหรับการแปลง JSON
import 'package:flutter/material.dart';

class Product {
  final String name;
  final String description;
  final double price;
  final int quantity;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });

  // เพิ่มฟังก์ชันสำหรับแปลง JSON เป็น Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // ตัวอย่างข้อมูลสินค้าในรูปแบบ JSON
  final String productsJson = '''
  [
    {"name": "Rose", "description": "Beautiful red roses", "price": 400, "quantity": 10},
    {"name": "Tulip", "description": "Colorful tulip flowers", "price": 550, "quantity": 20},
    {"name": "Sunflower", "description": "Bright yellow sunflowers", "price": 500, "quantity": 15}
  ]
  ''';

  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProductsFromJson();
  }

  // แปลง JSON เป็น List<Product>
  void _loadProductsFromJson() {
    final List<dynamic> jsonData = jsonDecode(productsJson);
    products = jsonData.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flower Products'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed:
                _loadProductsFromJson, // ปุ่มกดเพื่อโหลดข้อมูลจาก JSON อีกรอบ
            child: const Text('Load Products from JSON'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: const Icon(Icons.local_florist),
                  title: Text(product.name),
                  subtitle: Text('Price: ${product.price} Baht'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Price: ${product.price} Baht',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Available Quantity: ${product.quantity}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
