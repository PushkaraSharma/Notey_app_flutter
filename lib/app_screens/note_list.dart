import 'dart:async';

import 'package:flutter/material.dart';

import 'package:notey/models/note.dart';

import 'package:notey/utils/database_helper.dart';

import 'package:notey/app_screens/add_note.dart';

import 'package:sqflite/sqflite.dart';





class NoteList extends StatefulWidget {



  @override

  State<StatefulWidget> createState() {



    return NoteListState();

  }

}



class NoteListState extends State<NoteList> {



  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note> noteList;

  int count = 0;



  @override

  Widget build(BuildContext context) {



    if (noteList == null) {

      noteList = List<Note>();

      updateListView();

    }



    return Scaffold(



      appBar: AppBar(

        title: Text('   Notey',style: TextStyle(fontSize: 40.0),),

      ),



      body: getNoteListView(),



      floatingActionButton: FloatingActionButton(

        onPressed: () {

          debugPrint('FAB clicked');

          navigateToDetail(Note('', '', 2), 'Add Note');

        },

        tooltip: 'Add Note',
        backgroundColor: Colors.lightGreen,
        child: Icon(Icons.add,color: Colors.black,),



      ),

    );

  }



  ListView getNoteListView() {



    TextStyle titleStyle = Theme.of(context).textTheme.subhead;



    return ListView.builder(

      itemCount: count,

      itemBuilder: (BuildContext context, int position) {

        return Card(

          color: Colors.white,

          elevation: 2.0,

          child: ListTile(



            leading: CircleAvatar(

              backgroundColor: getPriorityColor(this.noteList[position].priority),

              child: getPriorityIcon(this.noteList[position].priority),

            ),



            title: Text(this.noteList[position].title, style: TextStyle(color: Colors.black),),



            subtitle: Text(this.noteList[position].date,style:TextStyle(color: Colors.black) ,),



            trailing: GestureDetector(

              child: Icon(Icons.delete, color: Colors.black,),

              onTap: () {

                _delete(context, noteList[position]);

              },

            ),





            onTap: () {

              debugPrint("ListTile Tapped");

              navigateToDetail(this.noteList[position],'Edit Note');

            },



          ),

        );

      },

    );

  }



  // Returns the priority color

  Color getPriorityColor(int priority) {

    switch (priority) {

      case 1:

        return Colors.green;

        break;

      case 2:

        return Colors.lightGreenAccent;

        break;



      default:

        return Colors.lightGreenAccent;

    }

  }



  // Returns the priority icon

  Icon getPriorityIcon(int priority) {

    switch (priority) {

      case 1:

        return Icon(Icons.play_arrow,color: Colors.black,);

        break;

      case 2:

        return Icon(Icons.arrow_right,color: Colors.black);

        break;



      default:

        return Icon(Icons.arrow_right,color: Colors.black);

    }

  }



  void _delete(BuildContext context, Note note) async {



    int result = await databaseHelper.deleteNote(note.id);

    if (result != 0) {

      _showSnackBar(context, 'Note Deleted Successfully');

      updateListView();

    }

  }



  void _showSnackBar(BuildContext context, String message) {



    final snackBar = SnackBar(content: Text(message));

    Scaffold.of(context).showSnackBar(snackBar);

  }



  void navigateToDetail(Note note, String title) async {

    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {

      return NoteDetail(note, title);

    }));



    if (result == true) {

      updateListView();

    }

  }



  void updateListView() {



    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {



      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();

      noteListFuture.then((noteList) {

        setState(() {

          this.noteList = noteList;

          this.count = noteList.length;

        });

      });

    });

  }

}

