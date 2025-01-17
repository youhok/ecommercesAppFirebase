import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerces/services/database.dart';
import 'package:ecommerces/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  String? selectedCategory;

  // Cloudinary configuration
  final String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/dvkilp8oc/image/upload";
  final String uploadPreset =
      "storageimage"; // Set this in your Cloudinary account

  // Firebase instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<String> categoryItems = ['Watch', 'Laptop', 'TV', 'Headphones'];

  // Function to pick an image
  Future<void> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  // Function to upload an image to Cloudinary
  Future<String?> uploadImageToCloudinary(File image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body);
        return jsonResponse['secure_url'];
      } else {
        throw Exception("Failed to upload image to Cloudinary");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Image upload failed: $e"),
        backgroundColor: Colors.red,
      ));
      return null;
    }
  }

  // Function to upload the product to Firebase
  Future<void> uploadProduct() async {
    if (nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        detailController.text.isNotEmpty &&
        selectedCategory != null &&
        selectedImage != null) {
      // Show a loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Uploading product..."),
          backgroundColor: Colors.blue,
        ),
      );

      try {
        // Upload image to Cloudinary
        String? imageUrl = await uploadImageToCloudinary(selectedImage!);

        if (imageUrl != null) {
          // Prepare product data
          // ignore: unused_local_variable
          String productId = randomAlphaNumeric(10);
          String firstLetter =
              nameController.text.substring(0, 1).toUpperCase();

          Map<String, dynamic> productData = {
            "name": nameController.text,
            "price": priceController.text,
            "detail": detailController.text,
            "SearchKey": firstLetter,
            "UpdatedName": nameController.text.toUpperCase(),
            "category": selectedCategory,
            "image_url": imageUrl,
            "created_at": FieldValue.serverTimestamp(),
          };

          // Add to global "Products" collection
          await DatabaseMethods().addAllProducts(productData);

          // Add to specific category collection
          await DatabaseMethods().addProduct(productData, selectedCategory!);

          // Clear the form
          setState(() {
            selectedImage = null;
            nameController.clear();
            priceController.clear();
            detailController.clear();
            selectedCategory = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Product uploaded successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please provide all the required fields."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          "Add Product",
          style: AppWidget.semiboldTextFeild(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload the Product Image",
                  style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: getImage,
                child: Center(
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            selectedImage!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Name", style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Price", style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Detail", style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: detailController,
                  maxLines: 3,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Product Category", style: AppWidget.lightTextFeildStyle()),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  underline: SizedBox(),
                  hint: Text("Select a category",
                      style: AppWidget.lightTextFeildStyle()),
                  items: categoryItems.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: AppWidget.semiboldTextFeild()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  uploadProduct();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: Color(0xFF66D1C1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Text(
                      "Add Product",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
