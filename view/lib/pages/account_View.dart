import 'package:flutter/material.dart';
import 'package:view/constants/text_style.dart';
import 'package:view/widgets/button/modify_User_Button.dart';
import 'package:view/services/user_svs.dart';
import 'package:view/models/User.dart';
import 'package:view/constants/route.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  User? currentUser;
  bool isLoading = true;
  String? errorMessage;

  Future<void> getUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 獲取存儲的 JWT token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      print('JWT Token: $token'); // Debug: 打印 token

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      User_SVS userService = User_SVS();
      var userData = await userService.getUserById(token); //放入獲得的token
      print('User Data: $userData'); // Debug: 打印獲得的使用者數據

      if (userData == null) {
        throw Exception('獲取使用者數據失敗');
      }

      setState(() {
        currentUser = userData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load user data: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserField(String field, String newValue) async {
    setState(() {
      isLoading = true;
    });
    try {
      // 獲取已儲存的 JWT token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      print('JWT Token: $token'); // Debug: 打印 token

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      User_SVS userService = User_SVS();
      var result = await userService.updateUser(token, field, newValue);
      if (result['success']) {
        // Update the local user data
        setState(() {
          if (field == 'name') currentUser?.name = newValue;
          if (field == 'email') currentUser?.email = newValue;
          if (field == 'password') currentUser?.password = newValue;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Updated successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
              "我的個人資料",
              style: UI_TextStyle.Title_TextStyle
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(120)),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text('NAME', style: UI_TextStyle.AccountTitle_TextStyle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentUser?.name ?? 'Loading...',
                    style: UI_TextStyle.AccountContext_TextStyle),
                ModifyUserButton(
                    orginalData: currentUser?.name ?? '',
                    onUpdateUser: (newValue) =>
                        _updateUserField('name', newValue)
                ).getButton(context),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            indent: 20.0,
            endIndent: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text('EMAIL', style: UI_TextStyle.AccountTitle_TextStyle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentUser?.email ?? 'Loading...',
                    style: UI_TextStyle.AccountContext_TextStyle),
                ModifyUserButton(
                    orginalData: currentUser?.email ?? '',
                    onUpdateUser: (newValue) =>
                        _updateUserField('email', newValue)
                ).getButton(context),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            indent: 20.0,
            endIndent: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text('Password', style: UI_TextStyle.AccountTitle_TextStyle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentUser?.password ?? 'Loading...',
                    style: UI_TextStyle.AccountContext_TextStyle),
                ModifyUserButton(
                    orginalData: currentUser?.password ?? '',
                    onUpdateUser: (newValue) =>
                        _updateUserField('password', newValue)
                ).getButton(context),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            indent: 20.0,
            endIndent: 20.0,
          ),
          // 添加一个 Spacer 来将登出按钮推到底部
          Spacer(),
          // 新增登出按钮
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('登出', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Routes.loginview);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
