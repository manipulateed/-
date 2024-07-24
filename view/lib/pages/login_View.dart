import 'package:flutter/material.dart';
import 'package:view/constants/route.dart';
import 'package:view/services/login_svs.dart';
import 'package:view/widgets/button/goto_Signup_or_Login.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String email = '452';
  String password = '2424';
  bool see = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      resizeToAvoidBottomInset: false,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Login.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Text('Login',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500)),
            ),
            Divider(
              height: 0,
              thickness: 3,
              indent: 30,
              endIndent: 255,
              color: Color(0xFFA5D6A7),
            ),
            SizedBox(height: 30,),
            Center(
                child:SizedBox(
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
                    initialValue: "demo@gamil.com",
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                      email = value.toString();
                    },
                    validator: (String? value) {
                      return (value != null && value.contains('@./\\*-+')) ? 'Do not use the special char.' : null;
                    },
                  ),
                ),
            ),
            SizedBox(height: 20,),
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
                      Login_SVS login = new Login_SVS(email: email, password: password);
                      login.sendData();
                      //Navigator.pushReplacementNamed(context, Routes.throughview);
                    },
                    child: Text(
                      'Login',
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
                  'Don\'t have an Account?',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GotoSignupOrLoginButton(message: 'Sign up').getButton(context, Routes.signupView),
              ],
            )
          ],
        ),
    );
  }
}
