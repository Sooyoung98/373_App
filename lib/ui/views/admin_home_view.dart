import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:tuple/tuple.dart';

class AdminHomeView extends StatelessWidget {
  var user;

  AdminHomeView({this.user});

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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: getCounts(),
              builder: (context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? Text("HI")
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Text(
                                  "Hello, " + user.fullName,
                                  style: headingStyle,
                                )),
                            // Row(children: [
                            Container(
                              padding: EdgeInsets.only(left: 70, right: 70),
                              child: GridView.count(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  mainAxisSpacing: 70,
                                  crossAxisSpacing: 70,
                                  crossAxisCount: 1,
                                  children: [
                                    _buildSingleContainer(
                                        icon: Icons.person,
                                        count: snapshot.data.item1.docs.length
                                            as int,
                                        name: "Total Users",
                                        context: context),
                                    _buildSingleContainer(
                                        icon: Icons.event_available_sharp,
                                        count: snapshot.data.item2.docs.length
                                            as int,
                                        name: "Active Events",
                                        context: context),
                                    // _buildSingleContainer(
                                    //     icon: Icons.person, count: 1, name: "User", context: context),
                                    // _buildSingleContainer(
                                    //     icon: Icons.person, count: 1, name: "User", context: context),
                                  ]),
                            )
                          ]);
              }),
        ));
  }

  Future getCounts() async {
    var data;
    QuerySnapshot users =
        await FirebaseFirestore.instance.collection('users').get();
    QuerySnapshot activeEvents = await FirebaseFirestore.instance
        .collection('events')
        .where("active", isEqualTo: true)
        .get();
    data = Tuple2(users, activeEvents);
    return data;
  }
}
