import 'package:encrypt/encrypt.dart' as enc;
import 'package:shared_preferences/shared_preferences.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  late enc.Key _key;
  late enc.IV _iv;

  factory EncryptionService() {
    return _instance;
  }

  EncryptionService._internal();

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedKey = prefs.getString('encryption_key');
    String? savedIv = prefs.getString('encryption_iv');

    if (savedKey == null || savedIv == null) {
      _key = enc.Key.fromSecureRandom(32); // AES-256
      _iv = enc.IV.fromSecureRandom(16);

      await prefs.setString('encryption_key', _key.base64);
      await prefs.setString('encryption_iv', _iv.base64);
    } else {
      _key = enc.Key.fromBase64(savedKey);
      _iv = enc.IV.fromBase64(savedIv);
    }
  }

  String encrypt(String plainText) {
    final encrypter = enc.Encrypter(enc.AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    try {
      final encrypter = enc.Encrypter(enc.AES(_key));
      final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
      return decrypted;
    } catch (e) {
      return '';
    }
  }

  // PIN management
  Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPin = _hashPin(pin);
    await prefs.setString('app_pin', hashedPin);
  }

  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('app_pin');
    if (savedPin == null) return false;
    return savedPin == _hashPin(pin);
  }

  Future<bool> isPinSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('app_pin');
  }

  Future<void> removePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_pin');
  }

  String _hashPin(String pin) {
    // Simple hash for demonstration
    // In production, use a proper hashing library
    return pin.hashCode.toString();
  }
}
