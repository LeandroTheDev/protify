import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/models/connection.dart';
import 'package:protify/components/models/dialogs.dart';
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
            //Item Title
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
            SizedBox(
              height: screenSize.height * 0.4,
              child: AspectRatio(
                aspectRatio: 16 / 7,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Theme.of(context).secondaryHeaderColor,
                      width: 1.0,
                    ),
                  ),
                  child: const Text("A beautiful carousel of images here"),
                ),
              ),
            ),
            //Spacer
            const SizedBox(height: 20),
            //Context Buttons
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
                  // Review Button
                  ElevatedButton(
                    onPressed: () => DialogsModel.showAlert(context, title: "Alert", content: "This feature is not implemented yet"),
                    child: const Text("Review"),
                  ),
                  // Empty
                  const SizedBox(),
                  // Install Button
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Spacer
                  const SizedBox(),
                  //Description
                  SizedBox(
                    width: screenSize.width - 200,
                    child: Text(
                      jsonDecode(item["DESCRIPTION"])[preferences.language],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15),
                    ),
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
                    width: 100,
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
            ),
            // Reviews
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(5),
                width: screenSize.width * 0.8,
                child: Column(
                  children: [
                    // Review title
                    Text(
                      "Reviews",
                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) => Text(
                            "[Anonymous] This feature is not implemented yet",
                            style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 12),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
