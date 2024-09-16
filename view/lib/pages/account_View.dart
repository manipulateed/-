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
  String currentAvatarIcon = "1"; // 默認頭像
  List<String> avatarIcons = ['1', '2', '3'];


  Future<void> getUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      User_SVS userService = User_SVS();
      var userData = await userService.getUserById();
      print('User Data: $userData');

      if (userData == null) {
        throw Exception('獲取使用者數據失敗');
      }

      setState(() {
        currentUser = userData;
        currentAvatarIcon = userData.icon ?? "1"; // 假設User模型中有icon屬性
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
      User_SVS userService = User_SVS();
      var result = await userService.updateUser(field, newValue);
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

  Future<void> _updateUserAvatar(String newIcon) async {
    setState(() {
      isLoading = true;
    });
    try {
      User_SVS userService = User_SVS();
      var result = await userService.updateUser('icon', newIcon);
      if (result['success']) {
        setState(() {
          currentAvatarIcon = newIcon;
          if (currentUser != null) {
            currentUser!.icon = newIcon;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('頭像更新成功')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('頭像更新失敗: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新頭像時發生錯誤: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('選擇頭像'),
          content: Container(
            width: 300,
            height: 300,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: avatarIcons.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _updateUserAvatar(avatarIcons[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: currentAvatarIcon == avatarIcons[index] ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/accountIcon/${avatarIcons[index]}.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '我的個人資料',
          style: TextStyle(
            color: Color.fromRGBO(56, 107, 79, 1),
            fontWeight: FontWeight.bold,
            letterSpacing: 3
          )
        ),
        backgroundColor: Colors.green[100],
        elevation: 3,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/accountIcon/$currentAvatarIcon.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.edit),
                    onPressed: _showAvatarSelectionDialog,
                  ),
                ],
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
                child: Text('登出', style: TextStyle(fontSize: 18, color: Colors.black, letterSpacing: 5)),
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
