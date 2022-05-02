import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shim_app/models/shimuser.dart';
import 'package:shim_app/ui/components/input_field.dart';
import 'package:shim_app/ui/shared/ui_helpers.dart';
import 'package:shim_app/ui/style/theme.dart';
import 'package:shim_app/ui/widgets/busy_button.dart';
import 'package:shim_app/ui/widgets/expansion_list.dart';
import 'package:shim_app/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:shim_app/viewmodels/signup_view_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:email_validator/email_validator.dart';

class ProfileEditView extends StatefulWidget {
  final user;

  ProfileEditView({this.user});

  @override
  State<ProfileEditView> createState() => _ProfileViewState(
      fullNameController: TextEditingController(text: user.fullName),
      date: user.birthday,
      number: PhoneNumber(
          phoneNumber: user.phoneNumber.substring(2), isoCode: 'US'));
}

class _ProfileViewState extends State<ProfileEditView> {
  TextEditingController fullNameController;
  DateTime date;
  PhoneNumber number;
  late File _image;

  _ProfileViewState(
      {required this.fullNameController,
      required this.date,
      required this.number});

  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String initialCountry = 'US';
  @override
  Widget build(BuildContext context) {
    // Future getImage() async {
    //   ImagePicker picker = ImagePicker();
    //   var image = await picker.pickImage(source: ImageSource.gallery);

    //   setState(() {
    //     _image = image as File;
    //     print('Image Path $_image');
    //   });
    // }

    // Future uploadPic(BuildContext context) async {
    //   String fileName = basename(_image.path);
    //   FirebaseStorage storage = FirebaseStorage.instance;
    //   StorageReference firebaseStorageRef =
    //       FirebaseStorage.instance.ref().child(fileName);
    //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    //   // setState(() {
    //   //   print("Profile Picture uploaded");
    //   //   Scaffold.of(context)
    //   //       .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    //   // });
    // }

    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: _appBar(context),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Edit Profile',
                    style: headingStyle,
                  ),
                  verticalSpaceLarge,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 12),
                      CircleAvatar(radius: 80, backgroundColor: Colors.grey),
                      SizedBox(width: 12),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: CircleAvatar(
                      //     radius: 100,
                      //     backgroundColor: Color(0xff476cfb),
                      //     child: ClipOval(
                      //       child: new SizedBox(
                      //         width: 180.0,
                      //         height: 180.0,
                      //         child: (_image != null)
                      //             ? Image.file(
                      //                 _image,
                      //                 fit: BoxFit.fill,
                      //               )
                      //             : Image.network(
                      //                 "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                      //                 fit: BoxFit.fill,
                      //               ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 60.0),
                      //   child: IconButton(
                      //     icon: Icon(
                      //       Icons.camera,
                      //       size: 30.0,
                      //     ),
                      //     onPressed: () {
                      //       getImage();
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                  verticalSpaceLarge,
                  TextFormField(
                    controller: fullNameController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      //print(number.phoneNumber);
                      //this.number = number;
                    },
                    onInputValidated: (bool value) {
                      //print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: phoneController,
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(),
                    onSaved: (PhoneNumber number) {
                      this.number = number;
                    },
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: DateFormat.yMd().format(date),
                        prefixIcon: const Icon(Icons.cake),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () {
                        _getDateFromUser();
                      }),
                  verticalSpaceMedium,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Save',
                        busy: model.busy,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            String phone = number.toString();
                            if (fullNameController.text.isEmpty) {
                              fullNameController.text = widget.user.fullName;
                            }
                            if (phoneController.text.isEmpty) {
                              phone = widget.user.phoneNumber;
                            }
                            model.editProfile(
                                fullName: fullNameController.text,
                                birthday: date,
                                phoneNumber: phone);
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
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

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1800),
        lastDate: DateTime(2121));
    if (_pickerDate != null) {
      setState(() {
        date = _pickerDate;
      });
    } else {
      print("it's null or something is wrong");
    }
  }
}
