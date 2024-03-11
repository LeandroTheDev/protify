import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/models/connection.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatelessWidget {
  final Map item;
  const ItemPage({super.key, required this.item});

  startDownload() {}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final preferences = Provider.of<UserPreferences>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Top bar
            Row(
              children: [
                //Back button
                IconButton(
                  //Back to home screen
                  onPressed: () => Navigator.pop(context),
                  //Back icon
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
            ),
            //Spacer
            const SizedBox(height: 20),
            //Game Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(item["NAME"]),
                const SizedBox(),
              ],
            ),
            //Spacer
            const SizedBox(height: 20),
            //Images
            Container(
              color: Theme.of(context).primaryColor,
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.3,
            ),
            //Spacer
            const SizedBox(height: 20),
            //Install Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(),
                ElevatedButton(
                  onPressed: () => ConnectionModel.downloadItem(context, item["ID"]),
                  child: const Text("Install Game"),
                ),
              ],
            ),
            //Game Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Spacer
                const SizedBox(),
                //Description
                Text(jsonDecode(item["DESCRIPTION"])[preferences.language]),
                //Spacer
                const SizedBox(),
                //Languages Support
                SizedBox(
                  width: screenSize.width * 0.1,
                  child: ListView.builder(
                    itemCount: item["LANGUAGES"].length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) => Text(item["LANGUAGES"][index])),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
