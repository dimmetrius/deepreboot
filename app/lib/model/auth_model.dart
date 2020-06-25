import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
enum AuthModelState {
  UNDEFINED,
  PROCESSING,
  AUTHORIZED,
  UNAUTHORIZED
}
class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthModelState state = AuthModelState.UNDEFINED;
  FirebaseUser user;
  StreamSubscription userAuthSub;
  bool authError = false;
  String verificationId;

  Timer timer;

  AuthModel() {
    userAuthSub = _auth.onAuthStateChanged.listen((newUser) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      user = newUser;
      state = AuthModelState.AUTHORIZED;
      print(['userID', user?.uid]);
      authError = false;
      notifyListeners();
    }, onError: (e) {
      authError = true;
      state = AuthModelState.UNAUTHORIZED;
      notifyListeners();
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });

    timer = new Timer.periodic(Duration(seconds: 5), (Timer t) {
      // notifyListeners();
    });
  }

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

  bool get isAnonymous {
    assert(user != null);
    bool isAnonymousUser = true;
    for (UserInfo info in user.providerData) {
      if (info.providerId == "facebook.com" ||
          info.providerId == "google.com" ||
          info.providerId == "password") {
        isAnonymousUser = false;
        break;
      }
    }
    return isAnonymousUser;
  }

  bool get isAuthenticated {
    return user != null;
  }

  void signInAnonymously() {
    _auth.signInAnonymously();
  }

  void verifyPhoneNumber(String phoneNumber) async {
    state = AuthModelState.PROCESSING;
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);

      print('Received phone auth credential: $phoneAuthCredential');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      authError = true;
      state = AuthModelState.UNAUTHORIZED;
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      notifyListeners();
    };

    final PhoneCodeSent codeSent =
        (String _verificationId, [int forceResendingToken]) async {
      state = AuthModelState.PROCESSING;
      print('Please check your phone for the verification code.');
      verificationId = _verificationId;
      notifyListeners();
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String _verificationId) {
      state = AuthModelState.PROCESSING;
      verificationId = _verificationId;
      notifyListeners();
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void signInWithPhoneNumber(String code) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: code,
    );
    user = (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      authError = false;
      //notifyListeners();
    } else {
      authError = true;
      state = AuthModelState.UNAUTHORIZED;
      notifyListeners();
    }
  }

  void signOut() {
    verificationId = null;
    _auth.signOut();
  }
}
