import 'package:flutter/material.dart';
import 'package:notey/app_screens/add_note.dart';
import 'package:notey/app_screens/note_list.dart';

void main(){

  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        accentColor: Colors.black12,
        buttonColor: Colors.lightGreen,
        brightness: Brightness.light,

      ),
      home: NoteList(),
    );
  }

}