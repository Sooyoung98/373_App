import 'package:flutter/material.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  Widget _buildSingleContainer(
      {required IconData icon,
      required int count,
      required String name,
      required BuildContext context}) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.grey,
                    size: 35,
                  ),
                  SizedBox(width: 20),
                  Text(name,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 50),
              Align(
                  alignment: Alignment.center,
                  child: Text(count.toString(),
                      style: TextStyle(
                          fontSize: 50,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child:
              // Row(children: [
              Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
        child: GridView.count(
            mainAxisSpacing: 50,
            crossAxisSpacing: 50,
            crossAxisCount: 1,
            children: [
              _buildSingleContainer(
                  icon: Icons.person, count: 1, name: "User", context: context),
              _buildSingleContainer(
                  icon: Icons.event_available_sharp,
                  count: 1,
                  name: "Events",
                  context: context),
              // _buildSingleContainer(
              //     icon: Icons.person, count: 1, name: "User", context: context),
              // _buildSingleContainer(
              //     icon: Icons.person, count: 1, name: "User", context: context),
            ]),
      )
          // CircleAvatar(
          //   backgroundImage:
          //       NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
          //   radius: 50,
          //   child: Text('Eevee'),
          //   foregroundColor: Colors.red,
          // ),
          // CircleAvatar(
          //   radius: 50,
          //   child: Text('Eevee'),
          //   foregroundColor: Colors.blue,
          // ),
          // ]
          ),
    );
  }
}
