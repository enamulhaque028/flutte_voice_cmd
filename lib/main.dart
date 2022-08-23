import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_voice_cmd/product_details_page.dart';
import 'package:alan_voice/alan_voice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        '/second': (context) => const ProductDetailsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  _MyHomePageState() {
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "increment":
        _incrementCounter();
        break;
      case "forward":
        Navigator.pushNamed(context, '/second');
        break;
      case "back":
        Navigator.of(context).pop();
        break;
      default:
      debugPrint("Unknown command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              child: const Text('Open Product Details Page'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
