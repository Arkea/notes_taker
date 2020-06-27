import 'package:flutter/material.dart';
import 'StagerredView.dart';
import '../Model/Note.dart';
import 'dart:async';
import 'NotePage.dart';
import '../Model/Utility.dart';

enum viewType {
  List,
  Staggered
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Timer _refreshTimer;

  var notesViewType ;
  @override void initState() {
    notesViewType = viewType.Staggered;

    _refreshTimer = new Timer.periodic(Duration(seconds: 10), (timer) {
      // call insert query here
      setState(() {
        CentralStation.updateNeeded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(brightness: Brightness.light,
          actions: _appBarActions(),
          elevation: 1,
          backgroundColor: Colors.white,
          // centerTitle: true,
          title: Text("Notes Taker", style: TextStyle(fontSize: 24.0, color: CentralStation.fontColor),),
        ),
        body: SafeArea(child: _body(), right: true, left:  true, top: true, bottom: true,),
      );

  }

  Widget _body() {
    print(notesViewType);
    return Container(child: StaggeredGridPage(notesViewType: notesViewType,));
  }

/* responsible for creating a new route using the Navigator.push class*/
  void _newNoteTapped(BuildContext ctx) {
    // "-1" id indicates the note is not new
    var emptyNote = new Note(-1, "", "", DateTime.now(), DateTime.now(), Colors.white);
    Navigator.push(ctx,MaterialPageRoute(builder: (ctx) => NotePage(emptyNote)));
  }

  //sets the viewType to either grid or list based on the noteViewType value
  void _toggleViewType(){
    setState(() {
      CentralStation.updateNeeded = true;
      if(notesViewType == viewType.List)
      {
        notesViewType = viewType.Staggered;

      } else {
        notesViewType = viewType.List;
      }

    });
  }

  List<Widget> _appBarActions() {

    return [
      Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _toggleViewType() ,
            child: Icon(
              notesViewType == viewType.List ?  Icons.list : Icons.developer_board,
              size: 28.0,
              color: CentralStation.fontColor,
            ),
          ),
        ),
      ),
      
      Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _newNoteTapped(context) ,
            child: Icon(
              Icons.add,
              color: CentralStation.fontColor,
              size: 30.0,
            ),
          ),
        ),
      ),
    ];
  }

}
