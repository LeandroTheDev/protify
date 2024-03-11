import 'package:flutter/material.dart';
import 'package:protify/components/models/library.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: screenSize.width * 0.7 - 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your library is empty try adding a game to it",
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            //Add Game button
            SizedBox(
              height: 30,
              child: ElevatedButton(onPressed: () => LibraryModel.addItemModal(context), child: const Text("Add First Game")),
            ),
            const SizedBox(height: 10),
            Text(
              "Or install one",
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            //Add Game button
            SizedBox(
              height: 30,
              child: ElevatedButton(onPressed: () {}, child: const Text("Install Game")),
            ),
          ],
        ),
      ),
    );
  }
}
