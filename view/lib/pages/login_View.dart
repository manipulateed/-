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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool see = true;

  @override
  void initState() { //初始值設定
    super.initState();
    _emailController.text = "123@gmail";  // 設置初始值（如果需要）
    _passwordController.text = "123456789";  // 設置初始值（如果需要）
  }

  // 添加這個方法
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    Login_SVS login = Login_SVS(email: email, password: password);
    Map<String, dynamic> result = await login.sendData();

    if (result['success']) {
      // 登錄成功，導航到account.view.dart
      Navigator.pushReplacementNamed(context, Routes.accountView);
    } else {
      // 登錄失敗，顯示錯誤消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
            SizedBox(height: 20,),
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
                    onPressed: _handleLogin,
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
