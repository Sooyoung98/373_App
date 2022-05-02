import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:shim_app/ui/components/button.dart';
import 'package:shim_app/ui/components/input_field.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/style/theme.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:stacked/stacked.dart';

import '../../viewmodels/event_view_model.dart';
import '../widgets/busy_button.dart';

class EditEventView extends StatefulWidget {
  const EditEventView(
      {Key? key, required this.eventObject, required this.eventRef})
      : super(key: key);

  final eventObject;
  final eventRef;
  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  // final titleController = TextEditingController();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  // final descriptionController = TextEditingController();
  // final locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedColor = 0;
  String _selectedType = "Engagement";
  List<String> typeList = ["Engagement", "Recurring", "Urgent"];

  @override
  void initState() {
    super.initState();
    titleController =
        new TextEditingController(text: '${widget.eventObject.title}');
    descriptionController =
        new TextEditingController(text: '${widget.eventObject.description}');
    locationController =
        new TextEditingController(text: '${widget.eventObject.location}');
    _selectedDate = widget.eventObject.date;
    _endTime = widget.eventObject.endTime;
    _startTime = widget.eventObject.startTime;
    _selectedColor = widget.eventObject.color;
    _selectedType = widget.eventObject.repeatType;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddEventViewModel>.reactive(
        viewModelBuilder: () => AddEventViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            appBar: _appBar(context),
            body: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Edit Event",
                      style: headingStyle,
                    ),
                    MyInputField(
                        title: "Title",
                        hint: "Enter your title",
                        controller: titleController),
                    MyInputField(
                        title: "Description",
                        hint: "Enter your description",
                        controller: descriptionController),
                    // const MyInputField(
                    //     title: "Requirements", hint: "Enter your requirements"),
                    MyInputField(
                        title: "Location",
                        hint: "Enter your location",
                        controller: locationController),
                    MyInputField(
                        title: "Date",
                        hint: DateFormat.yMd().format(_selectedDate),
                        widget: IconButton(
                            icon: const Icon(Icons.calendar_today_outlined,
                                color: Colors.grey),
                            onPressed: () {
                              _getDateFromUser();
                            })),
                    Row(
                      children: [
                        Expanded(
                          child: MyInputField(
                              title: "Start Time",
                              hint: _startTime,
                              widget: IconButton(
                                  onPressed: () {
                                    _getTimeFromUser(isStartTime: true);
                                  },
                                  icon: const Icon(Icons.access_time_rounded,
                                      color: Colors.grey))),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: MyInputField(
                              title: "End Time",
                              hint: _endTime,
                              widget: IconButton(
                                  onPressed: () {
                                    _getTimeFromUser(isStartTime: false);
                                  },
                                  icon: const Icon(Icons.access_time_rounded,
                                      color: Colors.grey))),
                        )
                      ],
                    ),
                    MyInputField(
                        title: "Type",
                        hint: _selectedType,
                        widget: DropdownButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleStyle,
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue!;
                              // newValue == "Engagement"
                              //     ? _selectedColor == 0
                              //     : newValue == "Recurring"
                              //         ? _selectedColor == 1
                              //         : _selectedColor == 2;
                            });
                          },
                          items: typeList
                              .map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value!,
                                    style:
                                        const TextStyle(color: Colors.grey)));
                          }).toList(),
                        )),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _colorPallete(),
                        MyButton(
                            label: "Save",
                            onTap: () {
                              // model.addEvent(
                              //     title: titleController.text,
                              //     location: locationController.text,
                              //     date: _selectedDate,
                              //     color: _selectedColor,
                              //     endTime: _endTime,
                              //     startTime: _startTime,
                              //     repeatType: _selectedType,
                              //     description: descriptionController.text);
                              Navigator.pop(context);
                            })
                        //   title: 'Create Event',
                        //   busy: model.busy,
                        //   onPressed: () {
                        //     print("HEEEEEE");
                        //     model.addEvent(
                        //         title: titleController.text,
                        //         location: locationController.text,
                        //         date: _selectedDate,
                        //         color: _selectedColor,
                        //         endTime: _endTime,
                        //         startTime: _startTime,
                        //         repeatType: _selectedRepeat,
                        //         description: descriptionController.text);
                        //     //Navigator.pop(context);
                        //   },
                        // )
                      ],
                    )
                  ],
                )))));
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios,
                size: 20, color: Colors.black)));
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            _selectedType == "Engagement"
                ? _selectedColor = 0
                : _selectedType == "Recurring"
                    ? _selectedColor = 1
                    : _selectedColor = 2;
            return GestureDetector(
              // onTap: () {
              //   setState(() {
              //     _selectedColor = index;
              //   });
              // },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? Colors.blue
                      : index == 1
                          ? Colors.orange
                          : Colors.pink,
                  child: _selectedColor == index
                      ? Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("it's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }
}
// class AddEventView extends StatefulWidget {
//   const AddEventView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: _appBar(context),
//         body: Container(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: SingleChildScrollView(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Add Event",
//                   style: headingStyle,
//                 ),
//                 const MyInputField(title: "Title", hint: "Enter your title"),
//                 const MyInputField(
//                     title: "Description", hint: "Enter your description"),
//                 const MyInputField(
//                     title: "Location", hint: "Enter your location"),
//                     MyInputField(title: "Date", hint: DateFormat.yMd().format)
//               ],
//             ))));
//   }

//   _appBar(BuildContext context) {
//     return AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(Icons.arrow_back_ios,
//                 size: 20, color: Colors.black)));
//   }
// }
