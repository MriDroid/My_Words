import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import './provider/words.dart';

// Screens
import './screen/home_screen.dart';
import './screen/search_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Words()),
      ],
      child: MaterialApp(
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        home: HomeScreen(),
        routes: {
          SearchScreen.routeName: (_) => SearchScreen(),
        },
      ),
    );
  }
}
