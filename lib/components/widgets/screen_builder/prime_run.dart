import 'package:flutter/material.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class NvidiaPrimeRunCheckbox extends StatefulWidget {
  const NvidiaPrimeRunCheckbox({super.key});

  @override
  State<NvidiaPrimeRunCheckbox> createState() => _NvidiaPrimeRunCheckboxState();
}

class _NvidiaPrimeRunCheckboxState extends State<NvidiaPrimeRunCheckbox> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    bool enabled = provider.datas["EnablePrimeRunNvidia"] ?? false;
    return Row(
      children: [
        //Checkbox
        Checkbox(
          value: enabled,
          onChanged: (value) => setState(
            () {
              enabled = value!;
              provider.changeData("EnablePrimeRunNvidia", enabled);
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
        Text("Enable Prime Run NVIDIA", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        //Info Button
        IconButton(
          icon: const Icon(Icons.info),
          color: Theme.of(context).secondaryHeaderColor,
          onPressed: () => DialogsModel.showAlert(
            context,
            title: "Prime Run",
            content: "Uses the dedicated GPU (NVIDIA) to run the game, used when you have two GPUs (Hybrid GPUs), running at same time.",
          ),
        ),
      ],
    );
  }
}
