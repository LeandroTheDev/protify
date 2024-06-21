import 'package:flutter/material.dart';
import 'package:protify/debug/logs.dart';
import 'package:provider/provider.dart';

class LibraryProvider extends ChangeNotifier {
  List _items = [];
  get items => _items;

  /// Stores ALL items loaded
  void changeItems(List value) {
    _items = value;
  }

  int? _itemIndex;
  get itemIndex => _itemIndex;

  /// Stores the selected item, null if no items selected
  void changeItemIndex(int? value) {
    _itemIndex = value;
  }

  OverlayEntry? _itemInfo;
  get itemInfo => _itemInfo;

  /// Shows the item overlay by right clicking
  void changeItemInfo(BuildContext context, OverlayEntry value) {
    _itemInfo = value;
    Overlay.of(context).insert(_itemInfo!);
  }

  /// Closes the item overlay by right clicking
  void hideItemInfo() {
    if (_itemInfo != null) {
      _itemInfo!.remove();
      _itemInfo = null;
    }
  }

  Map<String, dynamic>? _itemSelected;
  get itemSelected => _itemSelected;

  /// Changes the selected item
  void changeItemSelected(Map<String, dynamic>? value) {
    _itemSelected = value;
  }

  Map<String, List<int>> _itemsCategories = {};
  get itemsCategories => _itemsCategories;

  /// Change the loaded item categories
  void changeItemsCategories(Map<String, List<int>> value) {
    _itemsCategories = value;
  }

  /// Add any item to a category
  void addItemCategory(String value, int itemIndex) {
    //Null check
    if (_itemsCategories[value] == null) {
      _itemsCategories[value] = [];
    }
    _itemsCategories[value]!.add(itemIndex);
  }

  bool _screenUpdate = true;
  get screenUpdate => _screenUpdate;

  /// Tell the context to update the screen in next update
  void changeScreenUpdate(bool value) => _screenUpdate = value;

  /// Notify listener to update the screens screen, consider having used the changeScreenUpdate funciton
  void updateScreen([bool? value]) {
    notifyListeners();
    DebugLogs.print("[Library] Screen Refreshed");
  }

  String _selectedItemCategory = "Uncategorized";
  String get selectedItemCategory => _selectedItemCategory;

  /// Change the actual category of the library
  void changeSelectedItemCategory(String value) {
    _selectedItemCategory = value;
  }

  /// Receive the original item index by the category and actual index of grid
  int getItemOriginalIndex(int index) => _itemsCategories[selectedItemCategory]![index];

  Offset _mousePosition = const Offset(0, 0);
  get mousePosition => _mousePosition;

  /// Mouse position used by the item info overlay (right click)
  void changeMousePosition(Offset value) {
    _mousePosition = value;
  }

  /// Automatically cleans the item selection
  void clearItemSelection() {
    _itemIndex = null;
    _itemSelected = null;
    DebugLogs.print("[Library] Data Selection Clean");
  }

  /// Change datas to the default datas
  void clearDatas() {
    _items = [];
    _itemsCategories = {};
    DebugLogs.print("[Library] Data Clean");
  }

  /// Returns the provider for getting the datas
  static LibraryProvider getProvider(BuildContext context) {
    return Provider.of<LibraryProvider>(context, listen: false);
  }

  /// Returns the provider for getting the datas with listener
  static LibraryProvider getProviderListenable(BuildContext context) {
    return Provider.of<LibraryProvider>(context, listen: true);
  }
}
