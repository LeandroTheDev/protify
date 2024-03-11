import 'package:flutter/material.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class NvidiaShaderCompileCheckbox extends StatefulWidget {
  const NvidiaShaderCompileCheckbox({super.key});

  @override
  State<NvidiaShaderCompileCheckbox> createState() => _NvidiaShaderCompileCheckboxState();
}

class _NvidiaShaderCompileCheckboxState extends State<NvidiaShaderCompileCheckbox> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    bool enabled = provider.datas["EnableNvidiaCompile"] ?? false;
    return Row(
      children: [
        //Checkbox
        Checkbox(
          value: enabled,
          onChanged: (value) => setState(
            () {
              enabled = value!;
              provider.changeData("EnableNvidiaCompile", enabled);
            },
          ),
          //Fill Color
          fillColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
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
        Text("Enable Shader Compile NVIDIA", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        //Info Button
        IconButton(
          icon: const Icon(Icons.info),
          color: Theme.of(context).secondaryHeaderColor,
          onPressed: () => DialogsModel.showAlert(
            context,
            title: "Shader Compile",
            content: "Sets the global enviroments from nvidia: \"__GL_SHADER_DISK_CACHE\" to 1 to enable compiling shaders and automatic configure shaders save location in shader configuration folder",
          ),
        ),
      ],
    );
  }
}
