import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:worldflow/Data/Managers/UserManager.dart';

import '../Consts/LocalDatabaseConstants.dart';
import '../Models/LocalDatabaseModels/UserModel.dart';

class HiveGlobal {
  HiveGlobal._();
  static final instance = HiveGlobal._(); //! Singleton
  late Box _box; //! Default Box

  // Box get box => _box; //! Getter

  Future<void> initHive() async {
    await Hive.initFlutter(); //! Hive init

    Hive.registerAdapter(UserModelAdapter()); //! Register Adapters

    //! Encryption For Security
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    var containsEncryptionKey = await secureStorage.containsKey(
        key: LocalDatabaseConstants.ENCRYPTION_KEY);
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(
          key: LocalDatabaseConstants.ENCRYPTION_KEY,
          value: base64UrlEncode(key));
    }

    String? encoded =
        await secureStorage.read(key: LocalDatabaseConstants.ENCRYPTION_KEY);

    var encryptionKey = base64Url.decode(encoded!);

    //! Open Box With Encryption And Assign To _box
    _box = await Hive.openBox(
      LocalDatabaseConstants.DATABASE_NAME,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    String? id = (await getData(LocalDatabaseConstants.USER))?.id;
    if (id != null) {
      UserManager().Id = id;
    }

    print("Hive Initiated");
  }

  Future<T> getData<T>(String key) async {
    return await _box.get(key);
  }

  Future<void> putData<T>(String key, T value) async {
    await _box.put(key, value);
  }

  Future<void> deleteData(String key) async {
    await _box.delete(key);
  }

  Future<void> clearData() async {
    await _box.clear();
  }

  Future<void> closeBox() async {
    await _box.close();
  }

  Future<void> deleteBox(String name) async {
    await Hive.deleteBoxFromDisk(name);
  }

  Future<void> deleteAllBox() async {
    await Hive.deleteFromDisk();
  }
}
