import 'dart:math';

import 'package:encrypt/encrypt.dart';

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
}
