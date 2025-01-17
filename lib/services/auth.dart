import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Signs out the currently logged-in user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }

  /// Deletes the currently logged-in user
  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.delete();
        print("User deleted successfully");
      } else {
        throw FirebaseAuthException(
            code: "user-not-found", message: "No user is currently signed in.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            "Error: User needs to reauthenticate before account deletion. Code: ${e.code}");
      } else {
        print("Error deleting user: ${e.message}");
      }
      rethrow;
    } catch (e) {
      print("Unexpected error: $e");
      rethrow;
    }
  }
}
