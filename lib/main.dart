import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'services/post_api_service.dart';
import 'homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PostApiService.create(),
      // Always call dispose on the ChopperClient to release resources
      dispose: (context, PostApiService service) => service.client.dispose(),
      child: MaterialApp(
        title: 'Rocket App',
        home: HomePage(),
      ),
    );
  }
}
