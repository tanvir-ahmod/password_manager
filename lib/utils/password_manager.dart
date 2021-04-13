import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/utils/constants.dart';

class PasswordManager {
  static String generateRandomKey(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static String encryptData(String plainText, String key) {
    final encryptionKey = Key.fromUtf8(key);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(encryptionKey));
    final encryptedString = encrypter.encrypt(plainText, iv: iv);
    return encryptedString.base64.toString();
  }

  static String decryptData(String encryptedText, String key) {
    final encryptionKey = Key.fromUtf8(key);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(encryptionKey));
    final decryptedString = encrypter.decrypt64(encryptedText, iv: iv);
    return decryptedString;
  }

  static Future<String> getDecryptedMasterPassword() async{
    final storage = new FlutterSecureStorage();
    String randomKey = await storage.read(key: Constants.RANDOM_KEY);
    String encryptedPassword = await storage.read(key: Constants.ENCRYPTED_MASTER_PASSWORD);

    return decryptData(encryptedPassword, randomKey);
  }
}
