import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerces/Admin/home_admin.dart';
import 'package:ecommerces/pages/login.dart';
import 'package:ecommerces/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();


  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, right: 20.0, left: 20.0),
          child: Column(
            children: [
              Lottie.asset(
                'images/AnimationAdmin.json',
                repeat: true, // Loop the animation
                reverse: false, // Do not play in reverse
                animate: true, // Start animation automatically
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Admin Panel",
                style: AppWidget.semiboldTextFeild(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "UserName",
                    style: AppWidget.semiboldTextFeild(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      controller: usernamecontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Username"),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Password",
                    style: AppWidget.semiboldTextFeild(),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                   Container(
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your password';
                          }
                          return null;
                        },
                        controller: userpasswordcontroller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      loginAdmin();
                    },
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: Colors.purple[400],
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text(
                            "Back to Sign In",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginAdmin() async {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) async {
      bool loggedIn = false;

      for (var result in snapshot.docs) {
        if (result.data()['username'] == usernamecontroller.text.trim() &&
            result.data()['password'] == userpasswordcontroller.text.trim()) {
          loggedIn = true;

          // Save admin login state
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isAdminLoggedIn', true);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeAdmin()),
          );
          break;
        }
      }

      if (!loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Invalid username or password",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      }
    });
  }
}


//   loginAdmin() {
//     FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
//       snapshot.docs.forEach((result) {
//         if (result.data()['username'] != usernamecontroller.text.trim()) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.red,
//             content: Text(
//               "Your id is not correct",
//               style: TextStyle(fontSize: 20.0),
//             ),
//           ));
//         } else if (result.data()['password'] !=
//             userpasswordcontroller.text.trim()) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.red,
//             content: Text(
//               "Your password is not correct",
//               style: TextStyle(fontSize: 20.0),
//             ),
//           ));
//         } else {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => HomeAdmin()));
//         }
//       });
//     });
//   }
// }