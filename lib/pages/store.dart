// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/connection.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool loaded = false;
  Map<int, Map?> showcase = {};

  Future<Map<int, Map?>> getShowcase() async {
    //Communicate with the server
    Map<int, Map?> showcaseItems = {};
    final responseShowcase = await Connection.sendMessage(context, address: "/store_showcase", requestType: "GET");
    //Check for errors
    if (Connection.errorTreatment(context, responseShowcase)) {
      //Swipe every games and add to the main games variable
      final List body = jsonDecode(responseShowcase.body)["content"];
      for (int i = 0; i < body.length; i++) {
        showcaseItems[body[i]] = null;
      }
    }
    for (int i = 0; i < showcaseItems.length; i++) {
      final responseItemInfo = await Connection.sendMessage(context, address: "/get_item_info&item=1", requestType: "GET");
    }
    return showcaseItems;
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    if (!loaded) {
      loaded = true;
      getShowcase().then((value) => setState(() => {}));
    }
    return Scaffold(
      body: Column(
        children: [
          //Top bar
          Row(
            children: [
              IconButton(
                //Back to home screen
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false),
                //Back icon
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
