import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:psiemens/views/login_screen.dart';

Future<void> main() async {
  // Carga las variables de entorno
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: LoginScreen(),
      //home: const MiApp(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.blue,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _counter > 0
                  ? "Contador en positivo"
                  : _counter < 0
                      ? "Contador en negativo"
                      : "Contador en cero",
              style: TextStyle(
                color: _counter > 0
                    ? Colors.green
                    : _counter < 0
                        ? Colors.red
                        : Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag:  'btnIncrement',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            heroTag: 'btnDecrement',
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            heroTag: 'btnReset',
            onPressed: _resetCounter,
            tooltip: 'Reset',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
