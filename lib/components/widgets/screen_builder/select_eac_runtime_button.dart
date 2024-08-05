import 'package:flutter/material.dart';
import 'package:protify/components/models/library.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

// ignore: must_be_immutable
class SelectEACRuntimeButton extends StatefulWidget {
  const SelectEACRuntimeButton({super.key});
  @override
  State<SelectEACRuntimeButton> createState() => _SelectEACRuntimeButtonState();
}

class _SelectEACRuntimeButtonState extends State<SelectEACRuntimeButton> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getListenProvider(context);
    return provider.datas["EnableEACRuntime"] == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Selected Launcher
              Text(
                provider.datas["SelectedEACRuntime"] ?? "Default EAC Runtime",
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
              //Spacer
              const SizedBox(height: 5),
              //Select Launcher Button
              ElevatedButton(
                onPressed: () => LibraryModel.selectRuntime(context, noRuntimeToDefaultRuntime: true).then((selectedRuntime) {
                  if (selectedRuntime == "none")
                    setState(
                      () => provider.changeData("SelectedEACRuntime", null),
                    );
                  else
                    setState(
                      () => provider.changeData("SelectedEACRuntime", selectedRuntime),
                    );
                }),
                child: const Text("Select EAC Runtime"),
              ),
            ],
          )
        : const SizedBox();
  }
}
