import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerces/pages/category_product.dart';
import 'package:ecommerces/pages/product_all.dart';
import 'package:ecommerces/pages/product_detail.dart';
import 'package:ecommerces/services/database.dart';
import 'package:ecommerces/services/shared_pref.dart';
import 'package:ecommerces/widget/support_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;

  List<String> categories = [
    "images/headphones.png",
    "images/laptop.png",
    "images/smartwatch.png",
    "images/smart-tv.png",
  ];

  List Categoryname = [
    "Headphones",
    "Laptop",
    "Watch",
    "TV",
  ];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = new TextEditingController();

  initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        search = false; // Reset the search state
      });
      return;
    }

    setState(() {
      search = true;
    });

    var capitalizedValue = value[0].toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        setState(() {
          for (var doc in docs.docs) {
            queryResultSet.add(doc.data());
          }
        });
      });
    } else {
      tempSearchStore = [];
      for (var element in queryResultSet) {
        if (element['UpdatedName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
  }

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: name == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin:
                    const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting and Profile Picture
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey," + name!,
                              style: AppWidget.boldTextFeildStyle(),
                            ),
                            Text("Good Morning",
                                style: AppWidget.lightTextFeildStyle()),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            image!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: searchcontroller,
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Products",
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: search
                              ? GestureDetector(
                                  onTap: () {
                                    search = false;
                                    tempSearchStore = [];
                                    queryResultSet = [];
                                    searchcontroller.text = "";
                                    setState(() {});
                                  },
                                  child: Icon(Icons.close))
                              : Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Categories Header
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Categories",
                                      style: AppWidget.semiboldTextFeild(),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20.0),

                              // Categories ListView
                              Row(
                                children: [
                                  Container(
                                      height: 130,
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.only(right: 20.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF66D1C1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "All",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  Expanded(
                                    child: SizedBox(
                                      height:
                                          130, // Fixed height for the ListView
                                      child: ListView.builder(
                                        itemCount: categories.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: CategoryTile(
                                              image: categories[index],
                                              name: Categoryname[index],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "All Products",
                                    style: AppWidget.semiboldTextFeild(),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductAll()));
                                    },
                                    child: Text(
                                      "See all",
                                      style: const TextStyle(
                                        color: Color(0xFF66D1C1),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                height: 240,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Products')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Center(
                                          child: Text("No Products Found"));
                                    }

                                    var products = snapshot.data!.docs;

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        var product = products[index].data()
                                            as Map<String, dynamic>;

                                        return ProductTile(
                                          image: product['image_url'],
                                          name: product['name'],
                                          price: product['price'].toString(),
                                          detail: product['detail'],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    image: data["image_url"],
                    name: data["name"],
                    price: data["price"],
                    detail: data["detail"])));
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 20),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data["image_url"],
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              data["name"],
              style: AppWidget.semiboldTextFeild(),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryTile extends StatelessWidget {
  String image, name;

  CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProduct(category: name)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 90,
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10,
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String image, name, price, detail;

  const ProductTile({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.network(
            image,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          Text(
            name,
            style: AppWidget.semiboldTextFeild(),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "\$$price",
                style: TextStyle(
                    color: Color(0xFF66D1C1),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 40.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        image: image,
                        name: name,
                        price: price,
                        detail: detail,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Color(0xFF66D1C1),
                      borderRadius: BorderRadius.circular(7)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


 // initiateSearch(value) {
  //   if (value.length == 0) {
  //     setState(() {
  //       queryResultSet = [];
  //       tempSearchStore = [];
  //     });
  //   }
  //   setState(() {
  //     search = true;
  //   });
  //   var capitalizedValue =
  //       value.substring(0, 1).toUpperCase() + value.substring(1);

  //   if (queryResultSet.isEmpty && value.length == 1) {
  //     DatabaseMethods().search(value).then((QuerySnapshot docs) {
  //       for (int i = 0; i < docs.docs.length; ++i) {
  //         queryResultSet.add(docs.docs[i].data());
  //       }
  //     });
  //   } else {
  //     tempSearchStore = [];
  //     queryResultSet.forEach((element) {
  //       if (element['UpdatedName'].startsWith(capitalizedValue)) {
  //         setState(() {
  //           tempSearchStore.add(element);
  //         });
  //       }
  //     });
  //   }
  // }