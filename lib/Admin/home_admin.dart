import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerces/Admin/categoryupdate/Laptop_screen.dart';
import 'package:ecommerces/Admin/categoryupdate/headphones_screen.dart';
import 'package:ecommerces/Admin/categoryupdate/tv_screen.dart';
import 'package:ecommerces/Admin/categoryupdate/watch_screen.dart';
import 'package:ecommerces/Admin/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_product.dart';
import 'admin_login.dart';
import 'admin_profile.dart';
import 'all_order.dart';
import '../widget/support_widget.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          "Admin",
          style: AppWidget.boldTextFeildStyle(),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[200],
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    "ADMIN DASHBOARD",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.home, color: Colors.blue), // Home icon color
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeAdmin()));
                },
              ),
              ListTile(
                leading: Icon(Icons.person,
                    color: Colors.green), // Profile icon color
                title: Text(
                  "Profile",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminProfile()));
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.watch, color: Colors.orange), // Watch icon color
                title: Text(
                  "Watch",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WatchScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.laptop,
                    color: Colors.purple), // Laptop icon color
                title: Text(
                  "Laptop",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LaptopScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.tv, color: Colors.red), // TV icon color
                title: Text(
                  "TV",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TvScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.headphones,
                    color: Colors.teal), // Headphones icon color
                title: Text(
                  "Headphones",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HeadphonesScreen()));
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              ListTile(
                leading: Icon(Icons.logout,
                    color: Colors.black), // Logout icon color
                title: Text(
                  "Log out",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isAdminLoggedIn', false);
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => AdminLogin()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dashboard",
                    style: AppWidget.boldTextFeildStyle(),
                  ),
                  Icon(
                    Icons.dashboard,
                    size: 30,
                    color: Colors.green,
                  )
                ],
              ),
              SizedBox(height: 20.0),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: isLandscape ? 3 : 2,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  _buildDashboardButton(
                    context,
                    color: Color(0xFF66D1C1),
                    icon: Icons.add,
                    label: "Add Product",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProduct()),
                    ),
                  ),
                  _buildDashboardButton(
                    context,
                    color: Colors.orange,
                    icon: Icons.shopping_bag_outlined,
                    label: "All Order",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllOrder()),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                "Table Products",
                style: AppWidget.lightTextFeildStyle(),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                height:
                    screenHeight * 0.5, // Ensures table fits within the screen
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Products')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No products found."));
                        }

                        final products = snapshot.data!.docs;

                        return DataTable(
                          columnSpacing: screenWidth * 0.05,
                          // ignore: deprecated_member_use
                          dataRowHeight: 80.0,
                          columns: [
                            DataColumn(label: Text('Image')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Price')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: products.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return DataRow(cells: [
                              DataCell(
                                data['image_url'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            20), // Adjust the radius as needed
                                        child: Image.network(
                                          data['image_url'],
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(Icons.image, size: 40),
                              ),
                              DataCell(Text(data['name'] ?? 'N/A')),
                              DataCell(Text(data['price'] + "\$" ?? 'N/A')),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Color(0xFF66D1C1)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProduct(
                                            productId: doc.id,
                                            productData: data,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Products')
                                          .doc(doc.id)
                                          .delete();
                                    },
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required Color color,
      required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 3.0,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35.0, color: Colors.white),
              SizedBox(height: 10.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
