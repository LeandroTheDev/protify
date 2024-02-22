import 'package:flutter/material.dart';
import 'package:protify/components/connection.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      loaded = true;
      Connection.sendMessage(context, address: "/store_main", requestType: "GET").then((response) {
        if (Connection.errorTreatment(context, response)) {
          //To do
        }
      });
    }
    return const Scaffold(
      body: Text("This feature is not implemented yet"),
    );
  }
}
