import 'package:flutter/material.dart';
import 'package:protify/components/models/library.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/data/user_preferences.dart';

class ItemInfoWidget {
  static OverlayEntry build(BuildContext context) {
    final LibraryProvider libraryProvider = LibraryProvider.getProvider(context);
    return OverlayEntry(
      builder: (context) => Positioned(
        left: libraryProvider.mousePosition.dx,
        top: libraryProvider.mousePosition.dy,
        child: Material(
          color: Colors.transparent,
          child: Container(
              width: 80,
              padding: const EdgeInsets.all(8.0),
              color: Theme.of(context).colorScheme.tertiary,
              child: Column(
                children: [
                  // Game Title
                  SizedBox(
                    width: 50,
                    child: Text(
                      libraryProvider.items[libraryProvider.itemIndex]["ItemName"] ?? "Unknown",
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Spacer
                  const SizedBox(height: 10),
                  // Edit Game
                  GestureDetector(
                    onTap: () => {
                      // Close the overlay
                      libraryProvider.hideItemInfo(),
                      // Open edit game modal
                      LibraryModel.editItemModal(context, libraryProvider.itemIndex ?? 0),
                    },
                    child: const SizedBox(
                      width: 70,
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Spacer
                  const SizedBox(height: 10),
                  // Category
                  GestureDetector(
                    onTap: () => {
                      // Close the overlay
                      libraryProvider.hideItemInfo(),
                      // Open category selector
                      LibraryModel.selectCategory(context, categories: libraryProvider.itemsCategories).then(
                        // Update the Category
                        (category) => {
                          UserPreferences.updateItemCategory(libraryProvider.itemIndex, category).then(
                            (itemsUpdated) {
                              libraryProvider.changeItems(itemsUpdated);
                              libraryProvider.changeScreenUpdate(true);
                              libraryProvider.updateScreen();
                            },
                          ),
                        },
                      )
                    },
                    child: const SizedBox(
                      width: 70,
                      child: Text(
                        'Category',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Spacer
                  const SizedBox(height: 10),
                  // Remove Game
                  GestureDetector(
                    onTap: () {
                      // Close the overlay
                      libraryProvider.hideItemInfo();
                      final previousLength = libraryProvider.items.length;
                      // Remove the game
                      UserPreferences.removeItem(libraryProvider.itemIndex, libraryProvider.items, context).then((itemsUpdated) {
                        // Check if something changed
                        if (previousLength != itemsUpdated.length) {
                          libraryProvider.changeScreenUpdate(true);
                          libraryProvider.updateScreen();
                        }
                      });
                    },
                    child: const SizedBox(
                      width: 70,
                      child: Text(
                        'Remove',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
