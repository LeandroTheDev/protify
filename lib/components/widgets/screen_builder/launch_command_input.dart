import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class LaunchCommandInput extends StatefulWidget {
  const LaunchCommandInput({super.key});

  @override
  State<LaunchCommandInput> createState() => _LaunchCommandInputState();
}

class _LaunchCommandInputState extends State<LaunchCommandInput> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    TextEditingController launchCommand = TextEditingController();
    launchCommand.text = provider.datas["LaunchCommand"] ?? "";
    launchCommand.addListener(() => provider.changeData("LaunchCommand", launchCommand.text));
    return SizedBox(
      height: 60,
      child: TextField(
        controller: launchCommand,
        decoration: InputDecoration(
          labelText: 'Launch Command',
          labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), // Cor da borda inferior quando o campo não está focado
          ),
        ),
        style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
      ),
    );
  }
}
