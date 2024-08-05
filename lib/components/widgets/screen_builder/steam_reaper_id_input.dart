import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class SteamReaperInputID extends StatefulWidget {
  const SteamReaperInputID({super.key});

  @override
  State<SteamReaperInputID> createState() => _SteamReaperInputIDState();
}

class _SteamReaperInputIDState extends State<SteamReaperInputID> {
  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    TextEditingController steamReaperId = TextEditingController();

    steamReaperId.text = provider.datas["SelectedReaperID"] ?? "";
    steamReaperId.addListener(() => provider.changeData("SelectedReaperID", steamReaperId.text));
    return SizedBox(
      height: 60,
      child: TextField(
        controller: steamReaperId,
        decoration: InputDecoration(
          labelText: 'Steam Reaper ID',
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
