import 'package:flutter/material.dart';
import 'package:view/constants/route.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:view/widgets/button/goto_Signup_or_Login.dart';

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
    bool see = false;
    bool see2 = false;
    String password = '';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 230,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Signup.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Text('Sign up',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
          ),
          Divider(
            height: 0,
            thickness: 3,
            indent: 30,
            endIndent: 290,
            color: Color(0xFFA5D6A7),
          ),
          SizedBox(height: 30,),
          Center(
            child: SizedBox(
              width: 350,
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
          ),
          SizedBox(height: 16,),
          Center(
            child: SizedBox(
                width: 350,
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
          ),
          SizedBox(height: 16,),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child:SizedBox(
                  width: 350,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Padding(
                        padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                        child: Icon(Icons.lock_outline),
                      ),
                      hintText: 'Give it a password!',
                      labelText: 'PASSWORD',
                    ),
                    initialValue: "**********",
                    obscureText: see,
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                      password = value.toString();
                    },
                    validator: (String? value) {
                      return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
                    },
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined),
                  onPressed: (){
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: SizedBox(
                  width: 350,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Padding(
                        padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                        child: Icon(Icons.lock_outline),
                      ),
                      hintText: 'Write Password Again!',
                      labelText: 'COMFIRM PASSWORD',
                    ),
                    initialValue: "**********",
                    obscureText: see2,
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                      if (value.toString() != password){

                      }
                      else{

                      }
                    },
                    validator: (String? value) {
                      return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
                    },
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined),
                  onPressed: (){

                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 25,),
          Center(
            child: Container(
              width: 330.0,
              height: 100.0, // 這裡的高度設為100，以確保Padding有效果
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA5D6A7), // 按鈕背景顏色
                  ),
                  onPressed: () {
                    //Navigator.pushReplacementNamed(context, Routes.throughview);
                  },
                  child: Text(
                    'Create an Account',
                    style: TextStyle(
                      color: Colors.white, // 將按鈕文字設為白色，以便與背景顏色對比
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an Account!',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GotoSignupOrLoginButton(message: 'Login').getButton(context, Routes.loginview),
            ],
          )
        ],
      ),
    );
  }
}
