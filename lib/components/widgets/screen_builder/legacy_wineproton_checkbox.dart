import 'package:flutter/material.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class LegacyWineProtonCheckbox extends StatefulWidget {
  const LegacyWineProtonCheckbox({super.key});

  @override
  State<LegacyWineProtonCheckbox> createState() => _LegacyWineProtonCheckboxState();
}

class _LegacyWineProtonCheckboxState extends State<LegacyWineProtonCheckbox> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    bool enabled = provider.datas["EnableLegacyWineProton"] ?? false;
    return Row(
      children: [
        //Checkbox
        Checkbox(
          value: enabled,
          onChanged: (value) => setState(
            () {
              enabled = value!;
              provider.changeData("EnableLegacyWineProton", enabled);
            },
          ),
          //Fill Color
          fillColor: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
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
        Text("Enable Legacy Wine Proton", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        //Info Button
        IconButton(
          icon: const Icon(Icons.info),
          color: Theme.of(context).secondaryHeaderColor,
          onPressed: () => DialogsModel.showAlert(
            context,
            title: "Enable Legacy Wine Proton",
            content: "Using old protons might require this option",
          ),
        ),
      ],
    );
  }
}
