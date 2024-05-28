import 'package:flutter/material.dart';
import 'package:view/constants/route.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];
  final config = CalendarDatePicker2WithActionButtonsConfig(
    calendarType: CalendarDatePicker2Type.single,
    disableModePicker: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 160,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup_1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text('Create Account',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 16,),
          SizedBox(
            width: 300,
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                  child: Icon(Icons.person_2_outlined),
                ),
                hintText: 'What your Name?',
                labelText: 'NAME',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
              },
            ),
          ),
          SizedBox(height: 16,),
          SizedBox(
              width: 300,
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                    child: Icon(Icons.mail_outline),
                  ),
                  hintText: 'Give it a Email!',
                  labelText: 'EMAIL',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String? value) {
                  return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
                },
              ),
            ),
          SizedBox(height: 16,),
          SizedBox(
              width: 300,
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                    child: Icon(Icons.lock_outline),
                  ),
                  hintText: 'Give it a password!',
                  labelText: 'PASSWORD',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String? value) {
                  return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
                },
              ),
          ),
          SizedBox(height: 16,),
          SizedBox(
            width: 300,
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                  child: Icon(Icons.lock_outline),
                ),
                hintText: 'Write Password Again!',
                labelText: 'COMFIRM PASSWORD',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
              },
            ),
          ),
          SizedBox(height: 16,),
          SizedBox(
            width: 300,
            child: Stack(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Padding(
                      padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                      child: Icon(Icons.calendar_month),
                    ),
                    hintText: 'What your Birthday?',
                    labelText: 'BIRTHDAY',
                  ),
                  initialValue: _singleDatePickerValueWithDefaultValue.toString(),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },

                  validator: (String? value) {
                    return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
                  },
                ),
                Positioned(
                  top: 25,
                  right: 5,
                  child: IconButton(
                    icon: Icon(Icons.now_widgets_outlined),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                              child: CalendarDatePicker2WithActionButtons(
                                config: config,
                                value: _singleDatePickerValueWithDefaultValue,
                                onValueChanged: (dates) => setState(
                                        () => _singleDatePickerValueWithDefaultValue = dates),
                              )
                          )
                      );
                    },
                  ),
                ),
              ],
            )

          ),
          SizedBox(height: 25,),
          Container(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF81C784), // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: (){},
                child: Text(
                  'SIGU UP -->',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '有帳號了嗎?',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.greenAccent,
                ),
                child: Text(
                  'LOG IN',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, Routes.loginview);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

