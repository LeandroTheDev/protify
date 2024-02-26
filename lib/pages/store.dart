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
  Map<int, Map?> mainGames = {};

  Future<Map<int, Map?>> getMainGames() async {
    //Communicate with the server
    final response = await Connection.sendMessage(context, address: "/store_main", requestType: "GET");
    //Check for errors
    if (Connection.errorTreatment(context, response)) {
      //Swipe every games and add to the main games variable
      final games = jsonDecode(response.body)["content"]["games"];
      for (int i = 0; i < games.length; i++) {
        mainGames[games[i]] = null;
      }
    }
    return mainGames;
  }

  @override
  Widget build(BuildContext context) {
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
          FutureBuilder(
            future: getMainGames(),
            builder: (context, future) {
              return future.hasData
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 0,
                        childAspectRatio: 0.5,
                      ),
                      shrinkWrap: true,
                      itemCount: mainGames.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => {},
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Text(
                                mainGames[index] == null ? "Loading..." : mainGames[index]!["Title"],
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
