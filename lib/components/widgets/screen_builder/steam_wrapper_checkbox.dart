import 'package:flutter/material.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class SteamWrapperCheckbox extends StatefulWidget {
  const SteamWrapperCheckbox({super.key});

  @override
  State<SteamWrapperCheckbox> createState() => _SteamWrapperCheckboxState();
}

class _SteamWrapperCheckboxState extends State<SteamWrapperCheckbox> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    bool enabled = provider.datas["EnableSteamWrapper"] ?? false;
    return Row(
      children: [
        //Checkbox
        Checkbox(
          value: enabled,
          onChanged: (value) => setState(
            () {
              enabled = value!;
              provider.changeData("EnableSteamWrapper", enabled);
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
        Text("Enable Steam Wrapper", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        //Info Button
        IconButton(
          icon: const Icon(Icons.info),
          color: Theme.of(context).secondaryHeaderColor,
          onPressed: () => DialogsModel.showAlert(
            context,
            title: "Steam Wrapper",
            content: "Helps lauching games and compatibility problems, use if you are having trouble launching your game",
          ),
        ),
      ],
    );
  }
}
