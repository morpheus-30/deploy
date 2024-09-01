// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SignUpProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   String? _verificationId;

//   Future<void> signUp({
//     required String name,
//     required String email,
//     required String password,
//     required String phone,
//     required String company,
//     required String teamSize,
//     String? salesCode,
//   }) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Add additional user info to Firestore or other database
//       // await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
//       //   'name': name,
//       //   'phone': phone,
//       //   'company': company,
//       //   'teamSize': teamSize,
//       //   'salesCode': salesCode,
//       // });

//       notifyListeners();
//     } catch (e) {
//       // Handle errors
//       print(e);
//     }
//   }

//   Future<void> verifyPhoneNumber(String phoneNumber) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         notifyListeners();
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print(e.message);
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId;
//         notifyListeners();
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//         notifyListeners();
//       },
//     );
//   }

//   Future<void> signInWithSmsCode(String smsCode) async {
//     if (_verificationId != null) {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: smsCode,
//       );
//       await _auth.signInWithCredential(credential);
//       notifyListeners();
//     }
//   }

//   User? get currentUser => _auth.currentUser;
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _verificationId = '';
  bool _isLoading = false;
  String _statusMessage = '';

  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    _isLoading = true;
    _statusMessage = '';
    notifyListeners();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _statusMessage = e.message ?? 'Verification failed';
          _isLoading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _statusMessage = 'Code sent to $phoneNumber';
          _isLoading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      _statusMessage = 'Failed to Verify Phone Number: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithSmsCode(String smsCode) async {
    _isLoading = true;
    _statusMessage = '';
    notifyListeners();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      _statusMessage = 'Signed in successfully';
    } catch (e) {
      _statusMessage = 'Failed to sign in: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
