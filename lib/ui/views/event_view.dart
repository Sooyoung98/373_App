import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shim_app/models/event.dart';
import 'package:shim_app/ui/components/button.dart';
import 'package:shim_app/ui/components/event_tile.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:intl/intl.dart';
import 'package:shim_app/ui/views/event_detail_view.dart';
import 'package:shim_app/ui/widgets/event_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class EventView extends StatelessWidget {
  var user;

  EventView({this.user});

  @override
  Widget build(BuildContext context) {
    var user = this.user;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(children: [
            _addEventBar(context),
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("events").snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                            // scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot? data =
                                  snapshot.data?.documents[index];

                              // if user.myEvents
                              Event? temp = Event(
                                  id: data!.documentID,
                                  title: data['title'],
                                  location: data['location'],
                                  date: data['date'].toDate(),
                                  color: data['color'],
                                  endTime: data['endTime'],
                                  startTime: data['startTime'],
                                  repeatType: data['repeatType'],
                                  description: data['description']);
                              return AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: SlideAnimation(
                                      child: FadeInAnimation(
                                          child: Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            // _showBottomSheet(context, temp);
                                            // Navigator.of(context)
                                            //     .pushNamed('EventDetailView');
                                            // Navigator.pushNamed(
                                            //     context, 'EventDetailView',
                                            //     arguments: EventDetailView(
                                            //       event: temp,
                                            //     ));
                                            Navigator.pushNamed(
                                                context, 'EventDetailView',
                                                arguments: EventDetailView(
                                                    eventObject: temp,
                                                    user: user,
                                                    going: false));
                                          },
                                          child:
                                              performCheck(user: user, e: temp))
                                    ],
                                  ))));
                              // return EventWidget(
                              // title: data!['title'],
                              // location: data['location'],
                              // date: data['date'].toDate(),
                              // color: data['color'],
                              // endTime: data['endTime'],
                              // startTime: data['startTime'],
                              // repeatType: data['repeatType'],
                              // description: data['description']);
                            },
                          ));
                  },
                ),
              ],
            )
          ]),
        ));
  }

  _showBottomSheet(BuildContext context, Event event) {
    Get.bottomSheet(Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.32,
        //MedMediaQuery.of(context).size.height*0.24 for
        color: Colors.white,
        child: Column(
          children: [
            Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300])),
            Spacer(),
            _bottomSheetButton(
              label: "View Event",
              onTap: () {
                Get.back();
              },
              clr: Colors.blue,
              context: context,
            ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                Get.back();
              },
              clr: Colors.red,
              context: context,
            ),
            SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red,
              context: context,
              isClose: true,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        )));
  }

  _bottomSheetButton({
    required String label,
    Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 55,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2, color: isClose == true ? Colors.grey : clr),
              borderRadius: BorderRadius.circular(20),
              color: isClose == true ? Colors.transparent : clr,
            ),
            child: Center(
                child: Text(
              label,
              style: isClose
                  ? titleStyle
                  : titleStyle.copyWith(color: Colors.white),
            ))));
  }

  _addEventBar(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: subHeadingStyle,
                      ),
                      Text(
                        "Today",
                        style: headingStyle,
                      )
                    ])),
            user.userRole == "Admin"
                ? MyButton(
                    label: "+ Add Event",
                    onTap: () => Navigator.of(context).pushNamed('EventView'))
                : Container()
          ],
        ));
  }

  performCheck({user, required Event e}) {
    List<dynamic> goingEvents = user.myEvents;
    bool found = false;

    for (Map<String, dynamic> m in goingEvents) {
      if (m['id'] == e.id) {
        found = true;
        break;
      }
    }
    return (found == true) ? Container() : EventTile(e);
  }
}

// import 'package:flutter/material.dart';
// import 'package:shim_app/fake_data.dart';
// import 'package:shim_app/styles.dart';
// import 'package:shim_app/models.dart';

// import 'add_todo_button.dart';
// import 'custom_rect_tween.dart';
// import 'hero_dialog_route.dart';

// class EventView extends StatelessWidget {
//   const EventView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   AppColors.backgroundFadedColor,
//                   AppColors.backgroundColor,
//                 ],
//                 stops: [0.0, 1],
//               ),
//             ),
//           ),
//           SafeArea(
//             child: _TodoListContent(
//               todos: fakeData,
//             ),
//           ),
//           const Align(
//             alignment: Alignment.bottomRight,
//             child: AddTodoButton(),
//           )
//         ],
//       ),
//     );
//   }
// }

// /// {@template todo_list_content}
// /// List of [Todo]s.
// /// {@endtemplate}
// class _TodoListContent extends StatelessWidget {
//   const _TodoListContent({
//     Key key,
//     @required this.todos,
//   }) : super(key: key);

//   final List<Todo> todos;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: todos.length,
//       padding: const EdgeInsets.all(16),
//       itemBuilder: (context, index) {
//         final _todo = todos[index];
//         return _TodoCard(todo: _todo);
//       },
//     );
//   }
// }

// /// {@template todo_card}
// /// Card that display a [Todo]'s content.
// ///
// /// On tap it opens a [HeroDialogRoute] with [_TodoPopupCard] as the content.
// /// {@endtemplate}
// class _TodoCard extends StatelessWidget {
//   /// {@macro todo_card}
//   const _TodoCard({
//     Key key,
//     @required this.todo,
//   }) : super(key: key);

//   final Todo todo;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           HeroDialogRoute(
//             builder: (context) => Center(
//               child: _TodoPopupCard(todo: todo),
//             ),
//           ),
//         );
//       },
//       child: Hero(
//         createRectTween: (begin, end) {
//           return CustomRectTween(begin: begin, end: end);
//         },
//         tag: todo.id,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Material(
//             color: AppColors.cardColor,
//             borderRadius: BorderRadius.circular(12),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: <Widget>[
//                   _TodoTitle(title: todo.description),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   if (todo.items != null) ...[
//                     const Divider(),
//                     _TodoItemsBox(items: todo.items),
//                   ]
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// {@template todo_title}
// /// Title of a [Todo].
// /// {@endtemplate}
// class _TodoTitle extends StatelessWidget {
//   /// {@macro todo_title}
//   const _TodoTitle({
//     Key key,
//     @required this.title,
//   }) : super(key: key);

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//     );
//   }
// }

// /// {@template todo_popup_card}
// /// Popup card to expand the content of a [Todo] card.
// ///
// /// Activated from [_TodoCard].
// /// {@endtemplate}
// class _TodoPopupCard extends StatelessWidget {
//   const _TodoPopupCard({Key key, this.todo}) : super(key: key);
//   final Todo todo;

//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: todo.id,
//       createRectTween: (begin, end) {
//         return CustomRectTween(begin: begin, end: end);
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Material(
//           borderRadius: BorderRadius.circular(16),
//           color: AppColors.cardColor,
//           child: SizedBox(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _TodoTitle(title: todo.description),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     if (todo.items != null) ...[
//                       const Divider(),
//                       _TodoItemsBox(items: todo.items),
//                     ],
//                     Container(
//                       margin: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.black12,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const TextField(
//                         maxLines: 8,
//                         cursorColor: Colors.white,
//                         decoration: InputDecoration(
//                             contentPadding: EdgeInsets.all(8),
//                             hintText: 'Write a note...',
//                             border: InputBorder.none),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// {@template todo_items_box}
// /// Box containing the list of a [Todo]'s items.
// ///
// /// These items can be checked.
// /// {@endtemplate}
// class _TodoItemsBox extends StatelessWidget {
//   /// {@macro todo_items_box}
//   const _TodoItemsBox({
//     Key key,
//     @required this.items,
//   }) : super(key: key);

//   final List<Item> items;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         for (final item in items) _TodoItemTile(item: item),
//       ],
//     );
//   }
// }

// /// {@template todo_item_template}
// /// An individual [Todo] [Item] with its [Checkbox].
// /// {@endtemplate}
// class _TodoItemTile extends StatefulWidget {
//   /// {@macro todo_item_template}
//   const _TodoItemTile({
//     Key key,
//     @required this.item,
//   }) : super(key: key);

//   final Item item;

//   @override
//   _TodoItemTileState createState() => _TodoItemTileState();
// }

// class _TodoItemTileState extends State<_TodoItemTile> {
//   void _onChanged(bool val) {
//     setState(() {
//       widget.item.completed = val;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Checkbox(
//         onChanged: _onChanged,
//         value: widget.item.completed,
//       ),
//       title: Text(widget.item.description),
//     );
//   }
// }
