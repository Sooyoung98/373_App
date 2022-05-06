import 'package:intl/intl.dart';
import 'package:shim_app/ui/components/input_field.dart';
import 'package:shim_app/ui/shared/ui_helpers.dart';
import 'package:shim_app/ui/widgets/busy_button.dart';
import 'package:shim_app/ui/widgets/expansion_list.dart';
import 'package:shim_app/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:shim_app/viewmodels/signup_view_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:email_validator/email_validator.dart';

class SignUpView extends StatefulWidget {
  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  late String _password;
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  DateTime _selectedDate = DateTime.now();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _appBar(context),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 38,
                    ),
                  ),
                  verticalSpaceLarge,
                  TextFormField(
                    controller: fullNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Don't leave this blank";
                      }
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      //print(number.phoneNumber);
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
                  verticalSpaceSmall,
                  TextFormField(
                    controller: emailController,
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "Please enter a valid email",
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: DateFormat.yMd().format(_selectedDate),
                        prefixIcon: const Icon(Icons.cake),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () {
                        _getDateFromUser();
                      }),
                  verticalSpaceSmall,
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _toggle();
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    validator: (val) =>
                        val!.length < 6 ? 'Password too short.' : null,
                    obscureText: _obscureText,
                  ),
                  verticalSpaceSmall,
                  TextFormField(
                    controller: passwordConfirmController,
                    decoration: InputDecoration(
                        labelText: 'Confirm',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _toggle();
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Empty';
                      }
                      if (val != passwordController.text) {
                        return 'Password confirmation needs to match';
                      }
                      return null;
                    },
                    obscureText: _obscureText,
                  ),
                  verticalSpaceSmall,
                  // ExpansionList<String>(
                  //     items: ['Admin', 'User'],
                  //     title: model.selectedRole,
                  //     onItemSelected: model.setSelectedRole),
                  verticalSpaceMedium,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Sign Up',
                        busy: model.busy,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print(number.toString());
                            model.signUp(
                                email: emailController.text,
                                password: passwordController.text,
                                fullName: fullNameController.text,
                                birthday: _selectedDate,
                                phoneNumber: number.toString());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Invalid Input!")));
                          }
                        },
                      )
                    ],
                  )
                ],
              ),

              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     TextFormField(
              //       // The validator receives the text that the user has entered.
              //       validator: (value) {
              //         if (value == null || value.isEmpty) {
              //           return 'Please enter some text';
              //         }
              //         return null;
              //       },
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 16.0),
              //       child: ElevatedButton(
              //         onPressed: () {
              //           // Validate returns true if the form is valid, or false otherwise.
              //           if (_formKey.currentState!.validate()) {
              //             // If the form is valid, display a snackbar. In the real world,
              //             // you'd often call a server or save the information in a database.
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               const SnackBar(content: Text('Processing Data')),
              //             );
              //           }
              //         },
              //         child: const Text('Submit'),
              //       ),
              //     ),
              //   ],
              // ),
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
        _selectedDate = _pickerDate;
      });
    } else {
      print("it's null or something is wrong");
    }
  }
}
