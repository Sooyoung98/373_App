import 'package:flutter/material.dart';

class EventWidget extends StatefulWidget {
  final String title;
  final String location;
  final DateTime date;
  final int color;
  final String endTime;
  final String startTime;
  final String repeatType;
  final String description;

  EventWidget(
      {Key? key,
      required this.title,
      required this.location,
      required this.date,
      required this.color,
      required this.endTime,
      required this.startTime,
      required this.repeatType,
      required this.description})
      : super(key: key);

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Row(children: <Widget>[
          Container(
            height: 100,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 25),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0),
                    //   child: Text("Rs. ${widget.productPrice}",
                    //       style:
                    //           TextStyle(color: Colors.white, fontSize: 20)),
                    // )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        print("DELTETE!");
                        //deleteProduct(widget.documentSnapshot);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
