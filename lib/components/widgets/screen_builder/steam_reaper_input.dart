import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class SteamReaperInput extends StatefulWidget {
  const SteamReaperInput({super.key});

  @override
  State<SteamReaperInput> createState() => _SteamReaperInputState();
}

class _SteamReaperInputState extends State<SteamReaperInput> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    TextEditingController reaperId = TextEditingController();

    //Dependencies
    bool isVisible = ScreenBuilderProvider.getListenProvider(context).datas["SelectedRuntime"] != null;

    reaperId.text = provider.datas["SelectedReaperID"] ?? "";
    reaperId.addListener(() => provider.changeData("SelectedReaperID", reaperId.text));
    return isVisible
        ? SizedBox(
            height: 60,
            child: TextField(
              controller: reaperId,
              decoration: InputDecoration(
                labelText: 'Steam Reaper ID',
                labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), // Cor da borda inferior quando o campo não está focado
                ),
              ),
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
            ),
          )
        : const SizedBox();
  }
}
