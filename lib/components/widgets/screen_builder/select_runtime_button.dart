import 'package:flutter/material.dart';
import 'package:protify/components/models/library.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

// ignore: must_be_immutable
class SelectRuntimeButton extends StatefulWidget {
  const SelectRuntimeButton({super.key});
  @override
  State<SelectRuntimeButton> createState() => _SelectRuntimeButtonState();
}

class _SelectRuntimeButtonState extends State<SelectRuntimeButton> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Selected Launcher
        Text(
          provider.datas["SelectedRuntime"] ?? "No Runtime",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        //Spacer
        const SizedBox(height: 5),
        //Select Launcher Button
        ElevatedButton(
          onPressed: () => LibraryModel.selectRuntime(context).then((selectedRuntime) {
            if (selectedRuntime == "none")
              setState(
                () => provider.changeData("SelectedRuntime", null),
              );
            else
              setState(
                () => provider.changeData("SelectedRuntime", selectedRuntime),
              );
          }),
          child: const Text("Select Steam Runtime"),
        ),
      ],
    );
  }
}
