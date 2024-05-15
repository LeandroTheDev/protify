import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/models/connection.dart';
import 'package:protify/debug/logs.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class DownloadModel with ChangeNotifier {
  /// Stores the downloads objects
  Map<int, Map<String, dynamic>> downloads = {};

  /// Stores locally the socket to receive items downloads
  IOWebSocketChannel? serverChannel;

  /// Actual downloading item ID
  int? itemId;

  /// Read from storage all downloads to continue if exist
  void loadDownloads() {}

  /// Initializes the download for the specific item
  void startDownload(BuildContext context, int _itemId) {
    // Get Connection instance
    final ConnectionModel connection = Provider.of<ConnectionModel>(context, listen: false);
    // Get socket channel if not exist
    if (serverChannel == null) {
      serverChannel = IOWebSocketChannel.connect(
        "ws://127.0.0.1:6262",
        headers: {
          "username": connection.accountUsername,
          "token": connection.accountToken,
          "id": connection.accountId.toString(),
        },
      );
      itemId = itemId;
    }
    // If channel is set is because the user is already download a item
    else {
      // Add to the downloads section
      downloads[_itemId] = {
        "currentPart": 0,
        "finalPart": null,
      };
      return;
    }
  }

  /// Handles the received data from downloading item
  void downloadingItem() {
    if (itemId != null) {
      DebugLogs.print("[Download] Alert, a item is already downloading, cannot proceed");
      return;
    }
    sendMessageToSocket(String message) {
      //Send the socket to the server
      serverChannel!.sink.add(message);
    }

    //Broadcast download
    serverChannel!.stream.asBroadcastStream().listen(null).onData((data) {
      final Map response = jsonDecode(data);
      final String message = response["MESSAGE"];
      switch (message) {
        case "AUTHENTICATED":
          sendMessageToSocket(jsonEncode({
            "ACTION": "GET_ITEM_INFO",
            "ID": itemId.toString(),
          }));
          return;
        case "GAME_INFO":
          sendMessageToSocket(jsonEncode({
            "ACTION": "GET_ITEM_PART",
            "PART": 1,
          }));
          return;
      }
    });
    sendMessageToSocket(jsonEncode({
      "ACTION": "AUTHENTICATE",
      "ID": itemId.toString(),
    }));
  }
}
