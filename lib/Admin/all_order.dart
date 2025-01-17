import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerces/services/database.dart';
// import 'package:ecommerces/services/shared_pref.dart';
import 'package:ecommerces/widget/support_widget.dart';
import 'package:flutter/material.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({super.key});

  @override
  State<AllOrder> createState() => _OrderState();
}

class _OrderState extends State<AllOrder> {
  Stream? orderStream;

  getontheload() async {
    orderStream = await DatabaseMethods().AllOrders();
    setState(() {});
  }

  void initState() {
    getontheload();
    super.initState();
  }

  // Widget to display all orders
  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("An error occurred. Please try again later."),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No orders found."),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the product image with a fallback for null or invalid URLs
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Image.network(
                          ds["Image"] ?? "",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.image_not_supported,
                            size: 120,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: " + ds["Name"],
                              style: AppWidget.semiboldTextFeild(),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Email:" + ds["Email"],
                                style: AppWidget.lightTextFeildStyle(),
                              ),
                            ),
                            Text(
                              ds["Product"],
                              style: AppWidget.semiboldTextFeild(),
                            ),
                            Text(
                              "\$" + ds["Price"],
                              style: TextStyle(
                                  color: Color(0xFF66D1C1),
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await DatabaseMethods().updateStatus(ds.id);
                                // No need for setState(), StreamBuilder will auto-refresh
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xFF66D1C1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Done",
                                    style: AppWidget.semiboldTextFeild(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text(
          "All Order",
          style: AppWidget.boldTextFeildStyle(),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(child: allOrders()),
          ],
        ),
      ),
    );
  }
}
