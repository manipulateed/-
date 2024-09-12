// import 'package:flutter/material.dart';
// import 'package:view/constants/route.dart';
// import 'package:view/services/user_svs.dart';
// import 'package:view/models/User.dart';
// import 'package:calendar_date_picker2/calendar_date_picker2.dart';
// import 'package:view/widgets/button/goto_Signup_or_Login.dart';
//
// class SignupView extends StatefulWidget {
//   const SignupView({super.key});
//
//   @override
//   State<SignupView> createState() => _SignupViewState();
// }
//
// class _SignupViewState extends State<SignupView> {
//
//   User user = User(
//     name:'',
//     email: '452',
//     password: '2424',
//   );
//
//
//   List<DateTime?> _singleDatePickerValueWithDefaultValue = [
//     DateTime.now().add(const Duration(days: 1)),
//   ];
//   final config = CalendarDatePicker2WithActionButtonsConfig(
//     calendarType: CalendarDatePicker2Type.single,
//     disableModePicker: true,
//   );
//   @override
//   Widget build(BuildContext context) {
//     bool see = false;
//     bool see2 = false;
//     String password = '';
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.green[50],
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             height: 230,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/Signup.png'),
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
//             child: Text('Sign up',
//                 style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
//           ),
//           Divider(
//             height: 0,
//             thickness: 3,
//             indent: 30,
//             endIndent: 290,
//             color: Color(0xFFA5D6A7),
//           ),
//           SizedBox(height: 30,),
//           Center(
//             child: SizedBox(
//               width: 350,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   icon: Padding(
//                     padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
//                     child: Icon(Icons.person_2_outlined),
//                   ),
//                   hintText: 'What your Name?',
//                   labelText: 'NAME',
//                 ),
//                 onSaved: (String? value) {
//                   // This optional block of code can be used to run
//                   // code when the user saves the form.
//                   user.name = value.toString();
//                 },
//                 validator: (String? value) {
//                   return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
//                 },
//               ),
//             ),
//           ),
//           SizedBox(height: 16,),
//           Center(
//             child: SizedBox(
//                 width: 350,
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     icon: Padding(
//                       padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
//                       child: Icon(Icons.mail_outline),
//                     ),
//                     hintText: 'Give it a Email!',
//                     labelText: 'EMAIL',
//                   ),
//                   onSaved: (String? value) {
//                     // This optional block of code can be used to run
//                     // code when the user saves the form.
//                     user.email = value.toString();
//                   },
//                   validator: (String? value) {
//                     return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
//                   },
//                 ),
//               ),
//           ),
//           SizedBox(height: 16,),
//           Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               Center(
//                 child:SizedBox(
//                   width: 350,
//                   child: TextFormField(
//                     decoration: const InputDecoration(
//                       icon: Padding(
//                         padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
//                         child: Icon(Icons.lock_outline),
//                       ),
//                       hintText: 'Give it a password!',
//                       labelText: 'PASSWORD',
//                     ),
//                     initialValue: "**********",
//                     obscureText: see,
//                     onSaved: (String? value) {
//                       // This optional block of code can be used to run
//                       // code when the user saves the form.
//                       password = value.toString();
//                     },
//                     validator: (String? value) {
//                       return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
//                     },
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 15,
//                 right: 20,
//                 child: IconButton(
//                   icon: Icon(Icons.remove_red_eye_outlined),
//                   onPressed: (){
//                   },
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16,),
//           Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               Center(
//                 child: SizedBox(
//                   width: 350,
//                   child: TextFormField(
//                     decoration: const InputDecoration(
//                       icon: Padding(
//                         padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
//                         child: Icon(Icons.lock_outline),
//                       ),
//                       hintText: 'Write Password Again!',
//                       labelText: 'COMFIRM PASSWORD',
//                     ),
//                     initialValue: "**********",
//                     obscureText: see2,
//                     onSaved: (String? value) {
//                       // This optional block of code can be used to run
//                       // code when the user saves the form.
//                       if (value.toString() != password){
//
//                       }
//                       else{
//
//                       }
//                     },
//                     validator: (String? value) {
//                       return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
//                     },
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 15,
//                 right: 20,
//                 child: IconButton(
//                   icon: Icon(Icons.remove_red_eye_outlined),
//                   onPressed: (){
//
//                   },
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: 25,),
//           Center(
//             child: Container(
//               width: 330.0,
//               height: 100.0, // 這裡的高度設為100，以確保Padding有效果
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFA5D6A7), // 按鈕背景顏色
//                   ),
//                   onPressed: () {
//
//                     User_SVS userService = new User_SVS(user: user);
//                     userService.createUser();
//                     //Navigator.pushReplacementNamed(context, Routes.throughview);
//                   },
//                   child: Text(
//                     'Create an Account',
//                     style: TextStyle(
//                       color: Colors.white, // 將按鈕文字設為白色，以便與背景顏色對比
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 20,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Already have an Account!',
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               GotoSignupOrLoginButton(message: 'Login').getButton(context, Routes.loginview),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:view/constants/route.dart';
// import 'package:view/services/user_svs.dart';
import 'package:view/services/signup_svs.dart';
import 'package:view/models/User.dart';
import 'package:view/widgets/button/goto_Signup_or_Login.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _seePassword = true;
  bool _seeConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // 如果需要，可以在這裡設置初始值
    _nameController.text = "";
    _emailController.text = "";
    _passwordController.text = "";
    _confirmPasswordController.text = "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    User user = User(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    Signup_SVS userService = Signup_SVS(user: user);
    Map<String, dynamic> result = await userService.createUser();

    if (result['success']) {
      // 註冊成功，顯示成功消息並導航到登錄頁面
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, Routes.loginview);
    } else {
      // 註冊失敗，顯示錯誤消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
      // 不要導航到登錄頁面
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  icon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                    child: Icon(Icons.person_2_outlined),
                  ),
                  hintText: 'What your Name?',
                  labelText: 'NAME',
                ),
              ),
            ),
          ),
          SizedBox(height: 16,),
          Center(
            child: SizedBox(
              width: 350,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  icon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                    child: Icon(Icons.mail_outline),
                  ),
                  hintText: 'Give it a Email!',
                  labelText: 'EMAIL',
                ),
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
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      icon: Padding(
                        padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                        child: Icon(Icons.lock_outline),
                      ),
                      hintText: 'Give it a password!',
                      labelText: 'PASSWORD',
                    ),
                    obscureText: _seePassword,
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 20,
                child: IconButton(
                  icon: Icon(_seePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _seePassword = !_seePassword;
                    });
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
                  child: TextField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      icon: Padding(
                        padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                        child: Icon(Icons.lock_outline),
                      ),
                      hintText: 'Write Password Again!',
                      labelText: 'CONFIRM PASSWORD',
                    ),
                    obscureText: _seeConfirmPassword,
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 20,
                child: IconButton(
                  icon: Icon(_seeConfirmPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _seeConfirmPassword = !_seeConfirmPassword;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 25,),
          Center(
            child: Container(
              width: 330.0,
              height: 100.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA5D6A7),
                  ),
                  onPressed: _handleSignup,
                  child: Text(
                    'Create an Account',
                    style: TextStyle(
                      color: Colors.white,
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