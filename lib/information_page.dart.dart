import 'dart:developer';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final nameController = TextEditingController(text: '');
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  _InformationPageState() {
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
        getCurrentLocationAddress();
        break;
      case "getPhone":
        phoneController.text = command['text'];
        break;
      case "submit":
        submitDialog(context);
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
            ),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                icon: Icon(Icons.location_on),
                hintText: 'Where do you live?',
                labelText: 'Address *',
              ),
              readOnly: true,
              onTap: () => getCurrentLocationAddress(),
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                hintText: 'What is your phone number?',
                labelText: 'Phone Number *',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                submitDialog(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void submitDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hello ${nameController.text}"),
          content: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outlined, color: Colors.green, size: 40,)),
              const Text("Your information is recorded"),
            ],
          ),
        );
      },
    );
  }

  //>>>>>>>>>>calculate location>>>>>>>>>>
  Future<Position> getCurrentLocationAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      addressController.text = 'calculating.......';
    });

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var res = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = res.latitude;
      longitude = res.longitude;
    });
    log('Lat: ${res.latitude.toString()} Long: ${res.longitude.toString()}');
    List<Placemark> placemarks =
        await placemarkFromCoordinates(res.latitude, res.longitude);
    // log('Address: ${placemarks.map((e) => e.street)}');
    String geoAddress = placemarks.map((e) => e.street).toString();
    String formattedGeoAddress = geoAddress.substring(1, geoAddress.length - 1);
    setState(() {
      addressController.text = formattedGeoAddress;
    });
    return res;
  }
}