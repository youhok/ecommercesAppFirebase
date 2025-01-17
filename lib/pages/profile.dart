import 'dart:convert';
import 'dart:io';
import 'package:ecommerces/pages/onboarding.dart';
import 'package:ecommerces/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerces/services/database.dart';
import 'package:ecommerces/services/shared_pref.dart';
import 'package:ecommerces/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  final String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/dvkilp8oc/image/upload";
  final String uploadPreset = "storageimage";

  Future<String?> uploadImageToCloudinary(File imageFile,
      {String folder = "userprofile"}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(cloudinaryUrl),
      );

      // Specify the upload preset and folder
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder; // Specify folder name dynamically
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response to get the secure URL
        var responseData = await http.Response.fromStream(response);
        var responseJson = jsonDecode(responseData.body);
        return responseJson['secure_url']; // Return the image URL
      } else {
        // Handle the error if the upload fails
        throw Exception("Failed to upload image: ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e);
      return null; // Return null if there's an error
    }
  }

  Future<void> getImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        selectedImage = File(imageFile.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Uploading profile image..."),
          backgroundColor: Colors.blue,
        ),
      );

      try {
        String? imageUrl =
            await uploadImageToCloudinary(selectedImage!, folder: "imageuser");

        if (imageUrl != null) {
          String? userId = await SharedPreferenceHelper().getUserId();
          await DatabaseMethods().addUserDetails({
            "image": imageUrl,
            "name": name,
            "email": email,
          }, userId!);

          await SharedPreferenceHelper().saveUserImage(imageUrl);

          setState(() {
            image = imageUrl;
            selectedImage = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile image updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error uploading image: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No image selected."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  getthesharedpref() async {
    image = await SharedPreferenceHelper().getUserImage();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          "Profile",
          style: AppWidget.boldTextFeildStyle(),
        ),
      ),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: getImage,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : (image != null
                                    ? NetworkImage(image!)
                                    : AssetImage("assets/default_avatar.png"))
                                as ImageProvider,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_2_outlined,
                              size: 35,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: AppWidget.lightTextFeildStyle(),
                                ),
                                Text(
                                  name!,
                                  style: AppWidget.semiboldTextFeild(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail_outlined,
                              size: 35,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: AppWidget.lightTextFeildStyle(),
                                ),
                                Text(
                                  email!,
                                  style: AppWidget.semiboldTextFeild(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await AuthMethods().signOut().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Onboarding()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: 35,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Logout",
                                style: AppWidget.semiboldTextFeild(),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await AuthMethods().deleteUser().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Onboarding()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 35,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Delete Account",
                                style: AppWidget.semiboldTextFeild(),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
