import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashlightControl(),
    );
  }
}

class FlashlightControl extends StatefulWidget {
  const FlashlightControl({super.key});

  @override
  State<FlashlightControl> createState() => _FlashlightControlState();
}

class _FlashlightControlState extends State<FlashlightControl> {
  static const platform = MethodChannel('com.example.flashlight/flashlight');

  bool _isFlashlightOn = false;

  Future<void> _toggleFlashlight() async {
    try {
      final bool result = await platform.invokeMethod('toggleFlashlight');
      print(result);
      setState(() {
        _isFlashlightOn = result;
      });
    } on PlatformException catch (e) {
      print("Failed to toggle flashlight: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashlight Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                _isFlashlightOn ? Icons.flash_on : Icons.flash_off,
                key: ValueKey<bool>(_isFlashlightOn),
                size: 100.0,
                color: _isFlashlightOn ? Colors.yellow : Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Switch(
              value: _isFlashlightOn,
              onChanged: (value) async {
                await _toggleFlashlight();
              },
            ),
          ],
        ),
      ),
    );
  }
}
