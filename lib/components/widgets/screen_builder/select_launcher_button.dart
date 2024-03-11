import 'package:flutter/material.dart';
import 'package:protify/components/models/library.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

// ignore: must_be_immutable
class SelectLauncherButton extends StatefulWidget {
  const SelectLauncherButton({super.key});
  @override
  State<SelectLauncherButton> createState() => _SelectLauncherButtonState();
}

class _SelectLauncherButtonState extends State<SelectLauncherButton> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Selected Launcher
        Text(
          provider.datas["SelectedLauncher"] ?? "No Launcher",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        //Spacer
        const SizedBox(height: 5),
        //Select Launcher Button
        ElevatedButton(
          onPressed: () => LibraryModel.selectLauncher(context).then(
            (selectedLauncher) => setState(
              () => provider.changeData("SelectedLauncher", selectedLauncher),
            ),
          ),
          child: const Text("Select Launcher"),
        ),
      ],
    );
  }
}
