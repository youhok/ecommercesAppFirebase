import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerces/pages/product_detail.dart';
import 'package:ecommerces/services/database.dart';
import 'package:ecommerces/widget/support_widget.dart';
import 'package:flutter/material.dart';

class CategoryProduct extends StatefulWidget {
  final String category;
  const CategoryProduct({super.key, required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream<QuerySnapshot>? categoryStream;

  @override
  void initState() {
    super.initState();
    loadCategoryProducts();
  }

  void loadCategoryProducts() async {
    categoryStream = DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  Widget allProduct() {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No products available in this category."));
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return ProductCard(
              name: ds['UpdatedName'],
              price: ds['price'],
              imageUrl: ds['image_url'],
              detail: ds['detail'],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: Text(
          widget.category,
          style: AppWidget.semiboldTextFeild(),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: allProduct(),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final String detail; // Add a detail field

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.detail, // Initialize the detail field
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imageUrl,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 150, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            name,
            style: AppWidget.semiboldTextFeild(),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$$price",
                style: const TextStyle(
                  color: Color(0xFF66D1C1),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to ProductDetail and pass data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        image: imageUrl,
                        name: name,
                        price: price,
                        detail: detail, // Pass the detail
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF66D1C1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


