import 'package:flutter/material.dart';
import 'package:view/constants/route.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250,
              decoration: const BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage('assets/login_1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Text('Login',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 1),
              child: Text('Please sign in to continue.',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
            ),
            SizedBox(height: 20,),
            Center(
                child:SizedBox(
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
            ),
            SizedBox(height: 20,),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  child:SizedBox(
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
                ),
                Positioned(
                  top: 15,
                  right: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.greenAccent,
                    ),
                    child: Text(
                      'FORGET',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: (){

                    },
                  ),
                ),
              ],
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
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, Routes.throughview);
                  },
                  child: Text(
                    'LOGIN -->',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 120,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '沒有帳號嗎?',
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
                    'SIGN UP',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, Routes.signupView);
                  },
                ),
              ],
            )
          ],
        ),
    );
  }
}