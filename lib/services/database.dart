import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addAllProducts(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        .add(userInfoMap);
  }

  Future addProduct(
      Map<String, dynamic> userInfoMap, String categoryname) async {
    return await FirebaseFirestore.instance
        .collection(categoryname)
        .add(userInfoMap);
  }

  updateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .doc(id)
        .update({"Status": "Delivered"});
  }

  Stream<QuerySnapshot> getProducts(String category) {
    return FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future<Stream<QuerySnapshot>> AllOrders() async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .where("Status", isEqualTo: "On the way")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .where("Email", isEqualTo: email)
        .snapshots();
  }

  Future OrderDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .add(userInfoMap);
  }

  Future<QuerySnapshot> search(String updatedname) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        .where("SearchKey",
            isEqualTo: updatedname.substring(0, 1).toUpperCase())
        .get();
  }


  //get product to show on home screen
  Future<QuerySnapshot> getProductByName(String productName) async {
  return await FirebaseFirestore.instance
      .collection("Products")
      .where("name", isEqualTo: productName)
      .get();
}

}
