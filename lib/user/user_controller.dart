import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:parchemos/src/storage/memory_storage.dart';
import 'package:parchemos/src/user/user_data.dart';

import '../notification/notification_service.dart';
import 'user_service.dart';

class UserController with ChangeNotifier {
  UserController(this._userService, this._notificationService);

  final UserService _userService;
  final NotificationService _notificationService;
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
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  checkUserAuthenticated() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (MemoryStorage.instance.token != null) {
          _userService.singout().then((value) => _clearData());
        } else {
          notifyListeners();
        }
      } else {
        user.getIdToken().then((token) async =>
            _userService.singin(token).then((value) => _updateUserData(value)));
      }
    });
  }

  listenNewMesages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      MemoryStorage.instance.notifications = true;
      notifyListeners();
    });
  }

  _updateUserMessage(UserData userData, String? messageToken) {
    _notificationService.loadNotificationsNotSeen().then((int data) {
      MemoryStorage.instance.totalNotifications = data;
      if (data > 0) {
        MemoryStorage.instance.notifications = true;
        notifyListeners();
      }
    });
    if (messageToken != null) {
      userData.messageToken = messageToken;
      _userService.updateUser(userData);
    }
  }

  _clearData() {
    MemoryStorage.instance.clearData();
    loadSettings();
  }

  _updateUserData(UserData value) async {
    MemoryStorage.instance.userData = value;
    await loadSettings();
    MemoryStorage.instance.notifications;
    await _notificationService
        .start()
        .then((messageToken) => _updateUserMessage(value, messageToken));
    listenNewMesages();
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
