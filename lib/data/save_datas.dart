import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

class SaveDatas {
  /// Save datas of type: string, bool, int and double
  static Future saveData(String fileName, String dataName, dynamic dataValue) async {
    final StorageInstance storageInstance = StorageInstance.getInstance();
    await storageInstance.setValue(fileName, dataName, dataValue);
  }

  /// Read data based in name and type, the types consist in: 'string', 'int', 'bool', 'double'
  static Future<dynamic> readData(String fileName, String dataName) async {
    final StorageInstance storageInstance = StorageInstance.getInstance();
    return storageInstance.readValue(fileName, dataName);
  }

  /// Remove a file data based on fileName
  static Future removeData(String fileName) async {
    File file = File(join(StorageInstance.instanceDirectory!, fileName));
    file.deleteSync();
  }
}

class StorageInstance {
  static String? instanceDirectory;

  /// Based on name get the file or create a new, in instanceDirectory
  Future<File> _getFileOrCreate(String fileName) async {
    // Check if directory is null
    if (instanceDirectory == null) {
      throw "Instance Directory is null";
    }

    final file = File(join(instanceDirectory!, fileName));

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('{}');
    }

    return file;
  }

  /// Get the file and save it to the storage or create one and save with the value
  Future<void> setValue(String fileName, String dataName, dynamic dataValue) async {
    File dataFile = await _getFileOrCreate(fileName);
    String content = await dataFile.readAsString();
    Map<String, dynamic> datas = jsonDecode(content);
    datas[dataName] = dataValue;
    await dataFile.writeAsString(jsonEncode(datas));
  }

  /// Reads the value based on file name and data name, returns nulls if not exist
  Future<dynamic> readValue(String fileName, String dataName) async {
    try {
      File dataFile = await _getFileOrCreate(fileName);
      String content = await dataFile.readAsString();
      Map<String, dynamic> datas = jsonDecode(content);
      return datas[dataName];
    } catch (_) {
      return null;
    }
  }

  /// Changes the StorageInstance directory to save and find items
  static void setInstanceDirectory(String directory) => instanceDirectory = directory;

  /// Returns the storage instance for the actual storage directory
  static StorageInstance getInstance() => StorageInstance();
}
