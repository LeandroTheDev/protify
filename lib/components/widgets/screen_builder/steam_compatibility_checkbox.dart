import 'package:flutter/material.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class SteamCompatibilityCheckbox extends StatefulWidget {
  const SteamCompatibilityCheckbox({super.key});

  @override
  State<SteamCompatibilityCheckbox> createState() => _SteamCompatibilityCheckboxState();
}

class _SteamCompatibilityCheckboxState extends State<SteamCompatibilityCheckbox> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    bool enabled = provider.datas["EnableSteamCompatibility"] ?? false;
    return Row(
      children: [
        //Checkbox
        Checkbox(
          value: enabled,
          onChanged: (value) => setState(
            () {
              enabled = value!;
              provider.changeData("EnableSteamCompatibility", enabled);
            },
          ),
          //Fill Color
          fillColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.secondary;
              }
              return null;
            },
          ),
          //Check Color
          checkColor: Theme.of(context).colorScheme.tertiary,
          //Border Color
          side: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 2.0),
        ),
        //Text
        Text("Enable Steam Compatibility", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        //Info Button
        IconButton(
          icon: const Icon(Icons.info),
          color: Theme.of(context).secondaryHeaderColor,
          onPressed: () => DialogsModel.showAlert(
            context,
            title: "Steam Compatibility",
            content: "Enables steam compatibility making the game open with STEAM_COMPAT_CLIENT_INSTALL_PATH to use the official protons",
          ),
        ),
      ],
    );
  }
}
