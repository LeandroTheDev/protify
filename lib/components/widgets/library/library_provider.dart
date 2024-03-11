import 'package:flutter/material.dart';
import 'package:protify/debug/logs.dart';
import 'package:provider/provider.dart';

class LibraryProvider extends ChangeNotifier {
  List _items = [];
  get items => _items;
  void changeItems(List value) {
    _items = value;
  }

  int? _itemIndex;
  get itemIndex => _itemIndex;
  void changeItemIndex(int? value) {
    _itemIndex = value;
  }

  OverlayEntry? _itemInfo;
  get itemInfo => _itemInfo;
  void changeItemInfo(BuildContext context, OverlayEntry? value) {
    _itemInfo = value;
    Overlay.of(context).insert(_itemInfo!);
  }

  void hideItemInfo() {
    if (_itemInfo != null) {
      _itemInfo!.remove();
      _itemInfo = null;
    }
  }

  Map<String, dynamic>? _itemSelected;
  get itemSelected => _itemSelected;
  void changeItemSelected(Map<String, dynamic>? value) {
    _itemSelected = value;
  }

  Map<String, List<int>> _itemsCategories = {};
  get itemsCategories => _itemsCategories;
  void changeItemsCategories(Map<String, List<int>> value) {
    _itemsCategories = value;
  }

  void addItemCategory(String value, int itemIndex) {
    //Null check
    if (_itemsCategories[value] == null) {
      _itemsCategories[value] = [];
    }
    _itemsCategories[value]!.add(itemIndex);
  }

  bool _screenUpdate = true;
  get screenUpdate => _screenUpdate;
  void changeScreenUpdate(bool value) => _screenUpdate = value;
  void updateScreen([bool? value]) {
    notifyListeners();
    DebugLogs.print("Library Screen Refreshed");
  }

  String _selectedItemCategory = "Uncategorized";
  get selectedItemCategory => _selectedItemCategory;
  void changeSelectedItemCategory(String value) {
    _selectedItemCategory = value;
  }

  Offset _mousePosition = const Offset(0, 0);
  get mousePosition => _mousePosition;
  void changeMousePosition(Offset value) {
    _mousePosition = value;
  }

  /// Automatically cleans the item selection
  void clearItemSelection() {
    _itemIndex = null;
    _itemSelected = null;
    DebugLogs.print("Library Data Selection Clean");
  }

  /// Change datas to the default datas
  void clearDatas() {
    _items = [];
    _itemsCategories = {};
    DebugLogs.print("Library Data Clean");
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
