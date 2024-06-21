import 'package:flutter/material.dart';
import 'package:protify/components/widgets/library/item_info.dart';
import 'package:protify/components/widgets/library/library_provider.dart';

class GridGames extends StatelessWidget {
  const GridGames({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryProvider libraryProvider = LibraryProvider.getProviderListenable(context);
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height - 50,
      width: screenSize.width * 0.7 - 10,
      child: MouseRegion(
        onHover: (event) => libraryProvider.changeMousePosition(event.position),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 0,
            childAspectRatio: 0.5,
          ),
          shrinkWrap: true,
          itemCount: libraryProvider.itemsCategories[libraryProvider.selectedItemCategory] == null ? 0 : libraryProvider.itemsCategories[libraryProvider.selectedItemCategory].length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                int originalIndex = libraryProvider.getItemOriginalIndex(index);
                libraryProvider.changeItemIndex(originalIndex);
                // Update selection
                libraryProvider.changeItemSelected(libraryProvider.items[originalIndex]);
                libraryProvider.hideItemInfo();
                libraryProvider.updateScreen();
              },
              onSecondaryTap: libraryProvider.itemInfo == null
                  ? () {
                      int originalIndex = libraryProvider.getItemOriginalIndex(index);
                      libraryProvider.hideItemInfo();
                      // Update selection
                      libraryProvider.changeItemIndex(originalIndex);
                      // Create the gameInfo widget
                      libraryProvider.changeItemInfo(context, ItemInfoWidget.build(context));
                    }
                  : () => libraryProvider.hideItemInfo(),
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    libraryProvider.items[libraryProvider.itemsCategories[libraryProvider.selectedItemCategory]![index]]["ItemName"] ?? "Unknown",
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
    );
  }
}
