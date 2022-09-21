import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  int _selected =0;
  void changeSelected(int index){
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/1.jpg"), fit: BoxFit.cover),
              ),
              child: Column(
                children: const [
                  Image(
                      image: AssetImage("assets/W Logo txt .png"),
                      height: 100,),
                  SizedBox(height: 10,),
                  Text("Debug Page"),
                ],
              ),
            ),
             ListTile(
              selected: _selected ==0,
              leading: const Icon(
                CupertinoIcons.battery_full,
               // color: Colors.blue,
              ),
              title: const Text(
                "Palm battery",
                textScaleFactor: 1.2,
                style: TextStyle(
                 // color: Colors.blue,
                ),
              ),
               onTap: (){
                changeSelected(0);
               },
            ),

             ListTile(
              selected: _selected ==1,
              leading: const Icon(
                CupertinoIcons.battery_charging,
                //color: Colors.blue,
              ),
              title: const Text(
                "Remote Battery",
                textScaleFactor: 1.2,
                style: TextStyle(
                  //color: Colors.blue,
                ),
              ),
              onTap: (){
                changeSelected(1);
              },
            ),

             ListTile(
              selected: _selected ==2,
              leading: const Icon(
                CupertinoIcons.circle,
                //color: Colors.blue,
              ),
              title: const Text(
                "Palm Charging Count",
                textScaleFactor: 1.2,
                style: TextStyle(
                 // color: Colors.blue,
                ),
              ),
              onTap: (){
                changeSelected(2);
              },
            ),
            const Divider(
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
          ],
        ),
      ),
    );
  }
}
