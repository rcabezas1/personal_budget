import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../service/user_service.dart';
import '../storage/memory_storage.dart';
import '../user/user_data.dart';

class UserProvider with ChangeNotifier {
  UserProvider(this._userService);

  final UserService _userService;
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _themeMode = await _userService.themeMode(MemoryStorage.instance.userData);
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    if (MemoryStorage.instance.userData != null) {
      MemoryStorage.instance.userData!.theme = _themeMode.name;
      await _userService.updateUser(MemoryStorage.instance.userData!);
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    if (FirebaseAuth.instance.currentUser != null) {
      return await FirebaseAuth.instance.currentUser!
          .updateDisplayName(displayName);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signout() async {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  checkUserAuthenticated() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        if (MemoryStorage.instance.token != null) {
          await _userService.singout().then((value) => _clearData());
        } else {
          notifyListeners();
        }
      } else {
        await _userService
            .singin(user)
            .then((userData) => _updateUserData(userData));
      }
    });
  }

  addUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _userService
          .singin(currentUser)
          .then((userData) => _updateUserData(userData));
    }
  }

  _updateUserData(UserData value) async {
    MemoryStorage.instance.userData = value;
    await loadSettings();
  }

  _clearData() {
    MemoryStorage.instance.clearData();
    loadSettings();
  }

  bool isLogged() {
    return FirebaseAuth.instance.currentUser != null;
  }

  String getUserName() {
    return FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  String? getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}
