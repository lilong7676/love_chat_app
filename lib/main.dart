import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:love_chat/routes/MyRouter.dart';
import 'package:love_chat/models/user.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(builder: (context) => User()),
      ],
      child: MaterialApp(
        title: _title,
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: MyRouter.routes,
        onGenerateRoute: MyRouter.getRoute,
      ),
    );
  }
}
