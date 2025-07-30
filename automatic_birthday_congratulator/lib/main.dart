import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:automatic_birthday_congratulator/birthday_entry/data_entry_page.dart';
import 'package:automatic_birthday_congratulator/homepage.dart';
import 'package:automatic_birthday_congratulator/app_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState()..loadBirthdayMessages(),
      child: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Namer App',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: appState.currentColorScheme,
            ),
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  final Map<String, Color> colors = {
    'red': Colors.red,
    'orange': Colors.orange,
    'amber': Colors.amber,
    'yellow': Colors.yellow,
    'lime': Colors.lime,
    'green': Colors.green,
    'teal': Colors.teal,
    'cyan': Colors.cyan,
    'blue': Colors.blue,
    'indigo': Colors.indigo,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'brown': Colors.brown,
  };

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
      case 1:
        page = HomePage();
      case 2:
        page = DataEntryPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('New Birthday'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('change color scheme ->'),
                        ),

                        PopupMenuButton<Color>(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.grey,
                            size: 32,
                            semanticLabel: "adjust color scheme",
                          ),
                          offset: Offset(0, 55),
                          onSelected: (Color newColor) {
                            context.read<MyAppState>().changeColorScheme(
                              ColorScheme.fromSeed(seedColor: newColor),
                            );
                          },
                          itemBuilder:
                              (BuildContext context) => [
                                PopupMenuItem<Color>(
                                  enabled: false,

                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 300),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children:
                                            colors.entries
                                                .map(
                                                  (entry) =>
                                                      PopupMenuItem<Color>(
                                                        value: entry.value,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 24,
                                                              height: 24,
                                                              color:
                                                                  entry.value,
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(entry.key),
                                                          ],
                                                        ),
                                                      ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: page,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
