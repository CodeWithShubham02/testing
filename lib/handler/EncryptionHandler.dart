import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

String decryptText(String encryptedBase64, String key) {
  try {
    final keyHash = sha256.convert(utf8.encode(key)).bytes;
    final aesKey = encrypt.Key(Uint8List.fromList(keyHash.sublist(0, 16)));
    final iv = encrypt.IV(Uint8List.fromList(keyHash.sublist(16, 32)));

    final encrypter = encrypt.Encrypter(
      encrypt.AES(aesKey, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final decrypted = encrypter.decrypt64(encryptedBase64, iv: iv);
    return decrypted;
  } catch (e) {
    print("Decryption error: $e");
    return "Decryption Failed";
  }
}
String decryptFMS(String encryptedBase64, String hashKey) {
  // Hash the key using SHA256
  var keyHash = sha256.convert(utf8.encode(hashKey)).bytes;

  // Get 16-byte key and IV
  final keyBytes = Uint8List.fromList(keyHash.sublist(0, 16));
  final ivBytes = Uint8List.fromList(keyHash.sublist(0, 16));

  final key = encrypt.Key(keyBytes);
  final iv = encrypt.IV(ivBytes);

  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

  final decrypted = encrypter.decrypt64(encryptedBase64, iv: iv);
  return decrypted;
}