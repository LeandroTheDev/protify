import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/models/download.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class ConnectionModel with ChangeNotifier {
  String _httpAddress = "localhost:6161";
  String get httpAddress => _httpAddress;
  Future changeHttpAddress(String value) async {
    _httpAddress = value;
    await UserPreferences.savePreferencesInData(option: "HttpAddress", value: value);
  }

  String _socketAddress = "localhost:6262";
  String get socketAddress => _socketAddress;
  Future changeSocketAddress(String value) async {
    _socketAddress = value;
    await UserPreferences.savePreferencesInData(option: "SocketAddress", value: value);
  }

  int _accountId = 1;
  int get accountId => _accountId;
  changeAccountId(int value) => _accountId = value;

  String _accountUsername = "anonymous";
  String get accountUsername => _accountUsername;
  changeAccountUsername(String value) => _accountUsername = value;

  String _accountToken = "";
  String get accountToken => _accountToken;
  changeAccountToken(String value) => _accountToken = value;

  ///Comunicates the server via http request and return the response from the server
  ///
  ///address is the "/something" to communicate with the server
  ///
  ///requestType is the type from the url server GET/POST/DELETE
  ///
  ///body contains the informations you want to send to the server, ignored if is GET
  static Future<Response> sendMessage(
    BuildContext context, {
    required String address,
    required String requestType,
    Map<String, dynamic>? body,
  }) async {
    final ConnectionModel connection = Provider.of<ConnectionModel>(context, listen: false);

    Future<Response> getRequest() async {
      Response? result;
      try {
        result = await get(
          Uri.http(connection.httpAddress, address, body),
          headers: {
            "username": connection.accountUsername,
            "token": connection.accountToken,
            "id": connection.accountId.toString(),
          },
        );
      } catch (error) {
        if (result == null) {
          return Response(jsonEncode({"message": "No Connection: $error"}), 504);
        }
        return result;
      }
      return result;
    }

    Future<Response> postRequest() async {
      Response? result;
      try {
        result = await post(
          Uri.http(connection.httpAddress, address),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            "username": connection.accountUsername,
            "token": connection.accountToken,
            "id": connection.accountId.toString(),
          },
          body: jsonEncode(body ?? "{}"),
        );
      } catch (error) {
        if (result == null) {
          return Response(jsonEncode({"No Connection: $error"}), 504);
        }
        return result;
      }
      return result;
    }

    Future<Response> patchRequest() async {
      Response? result;
      try {
        result = await patch(
          Uri.http(connection.httpAddress, address),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            "username": connection.accountUsername,
            "token": connection.accountToken,
            "id": connection.accountId.toString(),
          },
          body: jsonEncode(body ?? "{}"),
        );
      } catch (error) {
        if (result == null) {
          return Response(jsonEncode({"No Connection: $error"}), 504);
        }
        return result;
      }
      return result;
    }

    Future<Response> deleteRequest() async {
      Response? result;
      try {
        result = await delete(
          Uri.http(connection.httpAddress, address),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            "username": connection.accountUsername,
            "token": connection.accountToken,
            "id": connection.accountId.toString(),
          },
          body: jsonEncode(body ?? "{}"),
        );
      } catch (error) {
        if (result == null) {
          return Response(jsonEncode({"No Connection: $error"}), 504);
        }
        return result;
      }
      return result;
    }

    switch (requestType) {
      case "GET":
        return await getRequest();
      case "POST":
        return await postRequest();
      case "PATCH":
        return await patchRequest();
      case "DELETE":
        return await deleteRequest();
      default:
        return Response(jsonEncode({"message": "Request Type not found"}), 401);
    }
  }

  ///Returns true if no error occurs, fatal erros return to home screen
  static bool errorTreatment(BuildContext context, Response response, {bool ignoreDialog = false}) {
    late final String message;
    try {
      message = jsonDecode(response.body)["MESSAGE"];
    } catch (_) {
      message = "Unknow Error ${response.statusCode}";
    }
    switch (response.statusCode) {
      //Temporary Banned
      case 413:
        if (!ignoreDialog) DialogsModel.showAlert(context, title: "Alert", content: message);
        return false;
      //Url Not Found
      case 404:
        if (!ignoreDialog) DialogsModel.showAlert(context, title: "Alert", content: message);
        return false;
      //Invalid Datas
      case 403:
        if (!ignoreDialog) DialogsModel.showAlert(context, title: "Alert", content: message);
        return false;
      //Wrong Credentials
      case 401:
        if (!ignoreDialog) DialogsModel.showAlert(context, title: "Alert", content: message);
        return false;
      //Server Crashed
      case 500:
        if (!ignoreDialog) DialogsModel.showAlert(context, title: "Alert", content: message);
        return false;
      //No connection with the server
      case 504:
        if (!ignoreDialog) DialogsModel.showAlert(context, title: "Alert", content: "Cannot connect to the servers");
        return false;
      //User Cancelled
      case 101:
        if (!ignoreDialog) DialogsModel.showAlert(context, title: "Alert", content: message);
        return false;
    }
    return true;
  }

  ///Start downloading the item,
  ///can automatically continue downloading the item if stopped sundently
  static void downloadItem(
    BuildContext context,
    int itemId,
  ) {
    final DownloadModel downloadModel = Provider.of<DownloadModel>(context, listen: false);
    // Initializes the download system
    downloadModel.startDownload(context, itemId);
  }
}
