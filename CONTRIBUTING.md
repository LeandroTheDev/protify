# Overview
### Shared Widgets
Multiples widgets that can be shared and probably will be shared in future needs to be created in ``components/screen_builder/my_widget_button.dart``.

screen_builder_provider.dart will store all datas from screen_builder widgets, the datas normally will be reseted every time a screen appears using the 
provider function screenBuilder.resetDatas()

### Models
Creating methods to do something will be in ``components/models/something.dart``, launcher.dart will only do launcher things, the library.dart will do only library things,
follow this parameters to know what to do.

All models needs to be static, models is for making the code cleanier, its receive the parameters and make things with that, consider not making manipulate code in the
widget itself, make a model for that.

# Creating
### Shared Widgets
- Create a file: ``components/widgets/screen_builder/my_custom_button.dart``

``Create a stateful widget or stateless depending on what you want``
```dart
import 'package:flutter/material.dart';

class MyCustomButton extends StatefulWidget {
  const MyCustomButton({super.key});

  @override
  State<MyCustomButton> createState() => _MyCustomButtonState();
}

class _MyCustomButtonState extends State<MyCustomButton> {
  @override
  Widget build(BuildContext context) {
    // Getting the provider to update and read datas
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    return const Placeholder();
  }
}
```
``Creates the widget body of your choice``
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    //Custom Text
    Text(
      provider.datas["CustomText"] == null ? "Nothing To Display" : basename(provider.datas["CustomSelection"]),
      style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
    ),
    //Spacer
    const SizedBox(height: 5),
    //Select a File
    ElevatedButton(
      onPressed: () => FilesystemPicker.open(
        context: context,
        rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
        fsType: FilesystemType.file,
        folderIconColor: Theme.of(context).secondaryHeaderColor,
      ).then((fileSelected) => setState(
        // This function is for saving the new data in storage
        // to be accessed by the model launcher in the future
        // this function accepts all primitive datas
        () => provider.changeData("CustomSelection", fileSelected),
      )),
      child: const Text("Select File"),
    ),
  ],
);
```
- Now your custom widget can be used in all screens in ``components/screens/``, check this example adding this custom button in ``add_item.dart``
```dart
...
//Select Game
const SelectGameButton(),
//Spacer
const SizedBox(height: 15),
//My custom button
const MyCustomButton(), // <--- Custom Button we Created
//Spacer
const SizedBox(height: 15),
//Select Prefix
const SelectPrefixButton(),
...
```

### Custom Screen
If you want to create a screen you can simple create a Widget
```dart
import 'package:flutter/material.dart';

class MyCustomScreen extends StatelessWidget {
  const MyCustomScreen({super.key});

  @override
  Widget build(BuildContext context) {
  ScreenBuilderProvider.resetProviderDatas(context); // This is recomended for resetting the data from screen_builders
    return const Placeholder();
  }
}
```
- To show up this screen you need a model for that, consider creating a new model if the screen doesn't belongs to library or others models
in ``components/models``
```dart
/// Create a modal for custom screen
static Future showCustomScreen(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    isScrollControlled: true,
    builder: (BuildContext context) => const MyCustomScreen(),
  );
}
```

### New options for Launcher/Adding a command in launcher
- Start by viewing how to create a new [Shared Widget](https://github.com/LeandroTheDev/protify/blob/main/CONTRIBUTING.md#shared-widgets-1)
- Go to add_item.dart and the edit_item.dart for adding your new shared widget.

- Now you can go to /components/models/launcher.dart
- Find the function you want to use the new option you created for example ``generateProtonStartCommand``

``Example``
```dart
static String generateProtonStartCommand(BuildContext context, Map item) {
  ...
  // This options add a new GLOBAL variable
  if(item["SelectedReaperID"] != null) {
    checkEnviroments += "${item["SelectedReaperID"]} "; // Consider always adding a space in the string final
  }
  ...
}
```

### New Preferences
- Go to /data/user_preferences.dart
- Find the functionn ``loadPreferences``
- Find the defaultData variable

``Add your new preference here``
```dart
final Map defaultData = {
  "MyNewPreference": "DefaultPreference",
};
```

``Create a new function in the UserPreferences class``
```dart
//Default Game Directory
String _myNewPreference = "";
get myNewPreference => _myNewPreference;
void changeMyNewPreference(String value) => {
  _myNewPreference = value,
  savePreferencesInData(option: "MyNewPreference", value: value),
};
```
- Now you can acess this preference using the ``final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);``