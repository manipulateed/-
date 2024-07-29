import 'package:flutter/material.dart';
import 'package:view/constants/text_style.dart';
import 'package:view/widgets/button/modify_User_Button.dart';
import 'package:view/services/user_svs.dart';
import 'package:view/models/User.dart';



class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  //late User_SVS user;
  //String name = user.name
  //late Future<Map<String, dynamic>?> account; // 用戶資料
  //取得user資料
  Map account = {'Name': 'Aden', 'Email': 'jimmy911116'};

  void getUser() async {
    // 從伺服器獲取使用者的邏輯
    User_SVS userService = User_SVS(user: User(name: '', email: '', password: ''));
    await userService.get_user_byUserID();
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getUser();

    void _updateName(String newName) {
      setState(() {
        account['Name'] = newName;
        User_SVS userService = User_SVS(user: User(name: '', email: '', password: ''));
        userService.updateUser('name', 'newName');
      });
    }
    void _updateEmail(String newEmail) {
      setState(() {
        account['Email'] = newEmail;
        User_SVS userService = User_SVS(user: User(name: '', email: '', password: ''));
        userService.updateUser('name', 'newName');
      });
    }
    void _updateBirthday(String newBirthday) {
      setState(() {
        account['Birthday'] = newBirthday;
        //user.updateUser(id, 'name', 'newName');
      });
    }

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
                  /*image: DecorationImage(
                    image: AssetImage('assets/shoulder.jpg'),
                    fit: BoxFit.cover,
                  ),*/
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(120)),
                ),
              ),
            ),
          ),
          SizedBox( height: 15.0,),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text('NAME', style: UI_TextStyle.AccountTitle_TextStyle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(account['Name'], style: UI_TextStyle.AccountContext_TextStyle),
                ModifyUserButton(orginalData: account['Name'], onUpdateUser: _updateName).getButton(context),
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
                Text(account['Email'], style: UI_TextStyle.AccountContext_TextStyle),
                ModifyUserButton(orginalData: account['Email'], onUpdateUser: _updateEmail).getButton(context),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            indent: 20.0,
            endIndent: 20.0,
          ),
          
        ],
      ),
    );
  }
}
