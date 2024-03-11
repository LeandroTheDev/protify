import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class ArgumentsCommandInput extends StatefulWidget {
  const ArgumentsCommandInput({super.key});

  @override
  State<ArgumentsCommandInput> createState() => _ArgumentsCommandInputState();
}

class _ArgumentsCommandInputState extends State<ArgumentsCommandInput> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    TextEditingController argumentsCommand = TextEditingController();
    argumentsCommand.text = provider.datas["Arguments"] ?? "";
    argumentsCommand.addListener(() => provider.changeData("Arguments", argumentsCommand.text));
    return SizedBox(
      height: 60,
      child: TextField(
        controller: argumentsCommand,
        decoration: InputDecoration(
          labelText: 'Arguments Command',
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
