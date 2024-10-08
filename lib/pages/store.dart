// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/models/connection.dart';
import 'package:protify/debug/logs.dart';
import 'package:protify/pages/item.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool loaded = false;
  bool failed = false;
  Map<int, Map?> showcase = {};

  Future getShowcase() async {
    DebugLogs.print("[Store] Requesting store showcases...");
    //Communicate with the server
    final responseShowcase = await ConnectionModel.sendMessage(context, address: "/store_showcase", requestType: "GET");
    // In cases the widget is disposed
    if (!context.mounted) return;

    //Check for errors
    if (ConnectionModel.errorTreatment(context, responseShowcase)) {
      //Swipe every games and add to the main games variable
      final List body = jsonDecode(responseShowcase.body);
      for (int i = 0; i < body.length; i++) setState(() => showcase[body[i]] = null);

      DebugLogs.print("[Store] Showcases received quantity: ${showcase.length}");

      DebugLogs.print("[Store] Downloading items informations...");

      //Getting the items info
      for (int i = 0; i < showcase.length; i++) {
        //Getting the item info
        ConnectionModel.sendMessage(context, address: "/get_item_info&item=${showcase.keys.elementAt(i)}", requestType: "GET").then((response) {
          if (ConnectionModel.errorTreatment(context, response, ignoreDialog: true)) {
            //Updating the info
            final Map body = jsonDecode(response.body);
            setState(() => showcase[body["ID"]] = body);

            DebugLogs.print("[Store] Item updated: $i");
          } else {
            DebugLogs.print("[Store] Cannot update the item: $i, reason: ${jsonDecode(response.body)["MESSAGE"]}");
            setState(() => failed = true);
          }
        });
      }
    } else {
      DebugLogs.print("[Store] Cannot receive showcase, reason: ${jsonDecode(responseShowcase.body)["MESSAGE"]}");
      setState(() => failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (!loaded) {
      loaded = true;
      //Get Showcase
      getShowcase();
    }

    //Convert showcase to List
    List items = [];
    showcase.entries.toList().forEach((item) => items.add(item.value));

    return Scaffold(
      body: Column(
        children: [
          //Top bar
          Row(
            children: [
              //Back button
              IconButton(
                //Back to home screen
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false),
                //Back icon
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ],
          ),
          items.isEmpty
              ? failed
                  // Failed Icon
                  ? Expanded(
                      child: Center(
                          child: Icon(
                      Icons.error_outline,
                      color: Theme.of(context).secondaryHeaderColor,
                    )))
                  // Loading widget
                  : const Expanded(child: Center(child: CircularProgressIndicator()))
              //Showcase
              : SizedBox(
                  width: screenSize.width * 0.9,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 0,
                      childAspectRatio: 0.5,
                    ),
                    shrinkWrap: true,
                    itemCount: showcase.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        //Game Page function
                        onTap: items[index] == null ? () {} : () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemPage(item: items[index]))),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Center(
                            //Game Title
                            child: Text(
                              items[index] == null ? "Loading..." : items[index]["NAME"],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
