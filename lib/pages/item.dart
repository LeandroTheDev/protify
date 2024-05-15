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
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ],
            ),
            //Spacer
            const SizedBox(height: 20),
            //Game Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  item["NAME"],
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(),
              ],
            ),
            //Spacer
            const SizedBox(height: 20),
            //Images
            Container(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.3,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 1.0,
                ),
              ),
              child: const Text("A beutiful carrousel of images here"),
            ),
            //Spacer
            const SizedBox(height: 20),
            //Install Button
            Container(
              width: screenSize.width * 0.85,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 2.0,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Empty
                  const SizedBox(),
                  // Install
                  ElevatedButton(
                    onPressed: () => ConnectionModel.downloadItem(context, item["ID"]),
                    child: const Text("Install"),
                  ),
                ],
              ),
            ),
            //Spacer
            const SizedBox(height: 15),
            //Game Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Spacer
                const SizedBox(),
                //Description
                Text(
                  jsonDecode(item["DESCRIPTION"])[preferences.language],
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15),
                ),
                //Spacer
                const SizedBox(),
                //Languages Support
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).secondaryHeaderColor,
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  width: screenSize.width * 0.1,
                  child: ListView.builder(
                    itemCount: item["LANGUAGES"].length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) => Text(
                          "${item["LANGUAGES"][index]},",
                          style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 12),
                        )),
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
