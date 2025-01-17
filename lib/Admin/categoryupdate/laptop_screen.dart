import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerces/widget/support_widget.dart';
import 'package:flutter/material.dart';

class LaptopScreen extends StatefulWidget {
  const LaptopScreen({super.key});

  @override
  State<LaptopScreen> createState() => _LaptopScreenState();
}

class _LaptopScreenState extends State<LaptopScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to update a document in the "Laptop" collection
  Future<void> updateLaptop(
      String docId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('Laptop').doc(docId).update(updatedData);
  }

  void showEditDialog(BuildContext context, DocumentSnapshot doc) {
    final TextEditingController updatedNameController =
        TextEditingController(text: doc['UpdatedName']);
    final TextEditingController categoryController =
        TextEditingController(text: doc['category']);
    final TextEditingController priceController =
        TextEditingController(text: doc['price'].toString());
    final TextEditingController detailController =
        TextEditingController(text: doc['detail']);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              final dialogWidth =
                  screenWidth * 0.8; // Dialog takes 80% of screen width
              return Container(
                width: dialogWidth,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  // Add this to make the content scrollable
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit Laptop Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: updatedNameController,
                          decoration: const InputDecoration(
                            labelText: 'Updated Name',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: categoryController,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: detailController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Detail',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Update the Firestore document
                              await updateLaptop(doc.id, {
                                'UpdatedName': updatedNameController.text,
                                'category': categoryController.text,
                                'price': priceController.text,
                                'detail': detailController.text,
                              });

                              Navigator.pop(context); // Close the dialog
                            },
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF66D1C1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Laptop Collection',
          style: AppWidget.boldTextFeildStyle(),
        ),
      ),
      body: SizedBox(
        height: screenHeight, // Allow the body to take full screen height
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('Laptop').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Laptops Found'));
                }

                final laptopDocs = snapshot.data!.docs;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    double columnSpacing = screenWidth *
                        0.05; // Adjust column spacing based on screen width
                    double rowHeight = 80.0; // Default row height
                    double imageWidth = screenWidth *
                        0.1; // Image width as a percentage of screen width

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DataTable(
                          columnSpacing: columnSpacing,
                          dataRowHeight: rowHeight,
                          columns: [
                            DataColumn(label: Text('Image')),
                            DataColumn(label: Text('Updated Name')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: laptopDocs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return DataRow(cells: [
                              DataCell(
                                data['image_url'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          data['image_url'],
                                          width:
                                              imageWidth, // Responsive image width
                                          height:
                                              imageWidth, // Responsive image height
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.image, size: 40),
                              ),
                              DataCell(Text(data['UpdatedName'] ?? 'N/A')),
                              DataCell(Text(data['category'] ?? 'N/A')),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        showEditDialog(context, doc),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      _firestore
                                          .collection('Laptop')
                                          .doc(doc.id)
                                          .delete();
                                    },
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
