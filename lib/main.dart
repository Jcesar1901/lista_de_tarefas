import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/Pages/TaskListPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate 
      ],
      supportedLocales: [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      home: TodoListPage(),
    );
  }
}

