import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  static const platform = MethodChannel('com.example.bravia/demo');
  String? demoMode;

  @override
  void initState() {
    super.initState();
    _getInitialData();
  }

  Future<void> _getInitialData() async {
    try {
      // Si necesitas recibir datos de Android
      final String? mode = await platform.invokeMethod('getDemoMode');
      setState(() {
        demoMode = mode ?? 'default';
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to get demo mode: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(demoMode == 'preview' ? 'Demo Preview' : 'Flutter Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => platform.invokeMethod('close'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Esta es una demostración de Flutter',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Continuar en Android'),
              onPressed: () => platform.invokeMethod('close'),
            ),
          ],
        ),
      ),
    );
  }
}