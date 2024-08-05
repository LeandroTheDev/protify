import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class PosLaunchCommandInput extends StatefulWidget {
  const PosLaunchCommandInput({super.key});

  @override
  State<PosLaunchCommandInput> createState() => _PosLaunchCommandInputState();
}

class _PosLaunchCommandInputState extends State<PosLaunchCommandInput> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    TextEditingController posLaunchCommand = TextEditingController();
    posLaunchCommand.text = provider.datas["PosLaunchCommand"] ?? "";
    posLaunchCommand.addListener(() => provider.changeData("PosLaunchCommand", posLaunchCommand.text));
    return SizedBox(
      height: 60,
      child: TextField(
        controller: posLaunchCommand,
        decoration: InputDecoration(
          labelText: 'Pos Launch Command',
          labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
      ),
    );
  }
}
