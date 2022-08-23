import 'dart:developer';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  _ProductDetailsPageState() {
    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton(
      "b011077636ddaef58251fd8cd676416e2e956eca572e1d8b807a3e2338fdd0dc/stage",
      buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
    );

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) {
      _handleCommand(command.data);
      log("got new command ${command.toString()}");
    });
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "getName":
        nameController.text = command['text'];
        break;
      case "getAddress":
        addressController.text = command['text'];
        break;
      case "getPhone":
        phoneController.text = command['text'];
        break;
      default:
      debugPrint("Unknown command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'What do people call you?',
                labelText: 'Name *',
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                  ? 'please enter your name'
                  : null;
              },
            ),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                icon: Icon(Icons.location_on),
                hintText: 'Where do you live?',
                labelText: 'Address *',
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                  ? 'please enter your address'
                  : null;
              },
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                hintText: 'What is your phone number?',
                labelText: 'Phone Number *',
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                  ? 'please enter your phone number'
                  : null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Subbmit'),
            ),
          ],
        ),
      ),
    );
  }
}