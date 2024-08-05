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
  File _getFileOrCreate(String fileName) {
    // Check if directory is null
    if (instanceDirectory == null) {
      throw "Instance Directory is null";
    }
    // File creation
    final file = File(join(instanceDirectory!, fileName));
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync("{}");
    }
    return file;
  }

  /// Get the file and save it to the storage or create one and save with the value
  setValue(String fileName, String dataName, dynamic dataValue) {
    File dataFile = _getFileOrCreate(fileName);
    Map datas = jsonDecode(dataFile.readAsStringSync());
    datas[dataName] = dataValue;
    dataFile.writeAsStringSync(jsonEncode(datas));
  }

  /// Reads the value based on file name and data name, returns nulls if not exist
  readValue(String fileName, String dataName) {
    try {
      File dataFile = _getFileOrCreate(fileName);
      Map datas = jsonDecode(dataFile.readAsStringSync());
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
