import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Email & Password Sign In (improved error handling)
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Sign in error [${e.code}]: ${e.message}');
      rethrow; // Let the caller handle the exception
    } catch (e) {
      print('Unexpected sign in error: $e');
      rethrow;
    }
  }

  // Email & Password Registration (improved error handling)
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Registration error [${e.code}]: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected registration error: $e');
      rethrow;
    }
  }

  // Google Sign In (improved error handling and null safety)
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Google sign in error [${e.code}]: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected Google sign in error: $e');
      rethrow;
    }
  }

  // Sign Out (improved with error handling)
  Future<void> signOut() async {
    try {
      await Future.wait([_googleSignIn.signOut(), _auth.signOut()]);
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Get current user (unchanged)
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Auth state changes (unchanged)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user getter (fixed implementation)
  User? get currentUser => _auth.currentUser;
}
