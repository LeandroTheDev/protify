import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class GameNameInput extends StatefulWidget {
  const GameNameInput({super.key});

  @override
  State<GameNameInput> createState() => _GameNameInputState();
}

class _GameNameInputState extends State<GameNameInput> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    TextEditingController gameName = TextEditingController();
    gameName.addListener(() => provider.changeData("ItemName", gameName.text));
    return SizedBox(
      height: 60,
      child: TextField(
        controller: gameName,
        decoration: InputDecoration(
          labelText: 'Name',
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
