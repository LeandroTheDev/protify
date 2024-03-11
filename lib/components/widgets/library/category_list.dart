import 'package:flutter/material.dart';
import 'package:protify/components/widgets/library/library_provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    final LibraryProvider libraryProvider = LibraryProvider.getProvider(context);
    final categoriesList = libraryProvider.itemsCategories.keys.toList();
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * 0.8 - 10,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categoriesList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => libraryProvider.changeSelectedItemCategory(categoriesList[index]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 1.0,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    categoriesList[index],
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
