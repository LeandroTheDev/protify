import 'package:flutter/material.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class ProtonScriptCheckbox extends StatefulWidget {
  const ProtonScriptCheckbox({super.key});

  @override
  State<ProtonScriptCheckbox> createState() => _ProtonScriptCheckboxState();
}

class _ProtonScriptCheckboxState extends State<ProtonScriptCheckbox> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    bool enabled = provider.datas["EnableProtonScript"] ?? false;
    return Row(
      children: [
        //Checkbox
        Checkbox(
          value: enabled,
          onChanged: (value) => setState(
            () {
              enabled = value!;
              provider.changeData("EnableProtonScript", enabled);
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
        Text("Enable Proton Script", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        //Info Button
        IconButton(
          icon: const Icon(Icons.info),
          color: Theme.of(context).secondaryHeaderColor,
          onPressed: () => DialogsModel.showAlert(
            context,
            title: "Proton Script",
            content: "All official protons have a python script in root folder of the proton, check this box to use it",
          ),
        ),
      ],
    );
  }
}
