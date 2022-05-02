import 'package:flutter/material.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(children: [
        CircleAvatar(
          backgroundImage:
              NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
          radius: 50,
          child: Text('Eevee'),
          foregroundColor: Colors.red,
        ),
        CircleAvatar(
          radius: 50,
          child: Text('Eevee'),
          foregroundColor: Colors.blue,
        ),
      ]),
    ));
  }
}
