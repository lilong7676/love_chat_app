import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:love_chat/routes/MyRouter.dart';
import 'package:love_chat/providers/userManager.dart';
import 'package:love_chat/providers/globalSettings.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'LoveChat';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(builder: (context) => UserManager()),
        ChangeNotifierProvider(
          builder: (_) => GlobalSettings(),
        ),
      ],
      child: Consumer<GlobalSettings>(
        builder: (context, globalSettings, child) {
          return MaterialApp(
            title: _title,
            theme: globalSettings.brightnessTheme,
            initialRoute: '/',
            routes: MyRouter.routes,
            onGenerateRoute: MyRouter.getRoute,
          );
        },
      ),
    );
  }
}
