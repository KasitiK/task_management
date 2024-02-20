import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const App()));
}
