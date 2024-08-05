# Overview
## Shared Widgets
Multiples widgets that can be shared and probably will be shared in future needs to be created in ``components/screen_builder/my_widget_button.dart``.

[screen_builder_provider.dart](https://github.com/LeandroTheDev/protify/blob/main/lib/components/widgets/screen_builder/screen_builder_provider.dart) will store all datas from screen_builder widgets, the datas normally will be reseted every time a screen appears using the 
provider function screenBuilder.resetDatas()

## Models
Creating methods to do something will be in ``components/models/something.dart``, launcher.dart will only do launcher things, the library.dart will do only library things,
follow this parameters to know what to do.

All models needs to be static, models is for making the code cleanier, its receive the parameters and make things with that, consider not manipulate code in the
widget itself, make a model for that.

# Creating
## Shared Widgets
- Create your new widget in: [components/widgets/screen_builder/my_custom_button.dart](https://github.com/LeandroTheDev/protify/tree/main/lib/components/widgets/screen_builder)

``Create a stateful widget or stateless depending on what you want, gerenally will be Stateful because you probably want to update the widget``
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
    //Select a Directory
    ElevatedButton(
      onPressed: () => FilePicker.platform.getDirectoryPath(
            dialogTitle: "Select Custom Directory",
            initialDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
          ).then((directory) {
            if (directory == null) {
              // Debug is very important to see where is the problem
              DebugLogs.print("Canceled");
              return;
            }
            setState(
              // This function is for saving the new data in storage
              // to be accessed by the model launcher in the future
              // this function accepts all primitive datas
              () => provider.changeData("CustomSelection", fileSelected),
            );
          }),
        child: const Text("Select Prefix"),
      ),
  ],
);
```
- Now your custom widget can be used in all screens on [components/screens/](https://github.com/LeandroTheDev/protify/tree/main/lib/components/screens), check this example adding this custom button in the screen: ``add_item.dart``
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

## Custom Screen
If you want to create a screen in normal cases you can simple create a Modal Widget for that, consider always creating the widgets in [Shared Widget](https://github.com/LeandroTheDev/protify/blob/main/CONTRIBUTING.md#shared-widgets-1) for standardization, also create your screen in [/components/screens/your_screen.dart](https://github.com/LeandroTheDev/protify/tree/main/lib/components/widgets/screen_builder)
```dart
import 'package:flutter/material.dart';

class MyCustomScreen extends StatelessWidget {
  const MyCustomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is recomended for resetting the data from screen_builders
    // so you can have a fresh datas from screen
    ScreenBuilderProvider.resetProviderDatas(context);
    return const Scaffold(...);
  }
}
```
- To show up this screen you need a model for that, consider creating a new model if the screen doesn't belongs to library or others models
in [components/models/my_screen.dart](https://github.com/LeandroTheDev/protify/tree/main/lib/components/models), for standardization if the context of your screen fits into an existing file, place the modal in this file
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

## New options for Launcher command
- Start by viewing how to create a new [Shared Widget](https://github.com/LeandroTheDev/protify/blob/main/CONTRIBUTING.md#shared-widgets-1)
- After creating the [shared widget](https://github.com/LeandroTheDev/protify/blob/main/CONTRIBUTING.md#shared-widgets-1) go to [add_item.dart](https://github.com/LeandroTheDev/protify/blob/main/lib/components/screens/add_item.dart) and the [edit_item.dart](https://github.com/LeandroTheDev/protify/blob/main/lib/components/screens/edit_item.dart) for adding your new shared widget (Good examples in the [Shared Widget](https://github.com/LeandroTheDev/protify/blob/main/CONTRIBUTING.md#shared-widgets-1)).

- Now you can go to [launcher.dart](https://github.com/LeandroTheDev/protify/blob/main/lib/components/models/launcher.dart)
- Find the function you want to use the new option you created for example ``generateProtonStartCommand``

``Example``
```dart
static String generateProtonStartCommand(BuildContext context, Map item) {
  ...
  // Every time you generate a proton command will check for this new option and add to the command
  if(item["SelectedReaperID"] != null) {
    checkEnviroments += "${item["SelectedReaperID"]} "; // Consider always adding a space in the string final
  }
  ...
}
```

- Now you need to read that value when opening the screen [edit_item.dart](https://github.com/LeandroTheDev/protify/blob/main/lib/components/screens/edit_item.dart) or whatever screen that uses this new option, go to [screen_builder_provider](https://github.com/LeandroTheDev/protify/blob/main/lib/components/widgets/screen_builder/screen_builder_provider.dart), and add new option for readData function

```dart
static void readData(BuildContext context, Map item) {
  final ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
  provider.setData({
    ...
    "SelectedReaperID": item["SelectedReaperID"] == "" ? null : item["SelectedReaperID"],
  });
}
```

## New Preferences
- Go to [/data/user_preferences.dart](https://github.com/LeandroTheDev/protify/blob/main/lib/data/user_preferences.dart)
- Find the function ``loadPreferences``
- Find the defaultData variable

``Add your new preference here``
```dart
final Map defaultData = {
  "MyNewPreference": "DefaultPreference",
};
```

``Create a new function in the UserPreferences class``
```dart
//Default My New Preference
String _myNewPreference = "";
get myNewPreference => _myNewPreference;
Future changeMyNewPreference(String value) async => {
  _myNewPreference = value,
  await savePreferencesInData(option: "MyNewPreference", value: value),
};
```
- Now you can access this preference using the ``final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);``

# Debugging
Personal recommendation: VSCODE with Flutter extension.

To start debugging first download the protify from [release](https://github.com/LeandroTheDev/protify/releases) or build it ``flutter build linux`` and get that build and place somewhere you like ``/home/you/programs/protify``, if you choose to build it them you need to create a file with name ``protify_finder.txt`` inside the ``protify/lib``, with everthing setup correctly you can start debugging using ``flutter run``.

### Adding logs
Recommended way to add logs is using the DebugLogs class, this will automatically use the debug print from flutter framework with the timestamp of your device.
```dart
DebugLogs.print("[Context] Debbuging variable: 123");
```