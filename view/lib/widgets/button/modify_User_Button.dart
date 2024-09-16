import 'package:flutter/material.dart';
import 'package:view/constants/button_style.dart';
import 'package:quickalert/quickalert.dart';

class ModifyUserButton {
  String message = '';

  dynamic Function(String) onUpdateUser;
  String orginalData = '';
  ModifyUserButton({
    required this.orginalData,
    required this.onUpdateUser,
  });

  void _handlePressed(String newUser) {
    onUpdateUser(newUser);
  }

  IconButton getButton(context){
    message = this.orginalData;
    return  IconButton(
      style: UI_ButtonStyle.modify_User_ButtonStyle,
      onPressed: () async{
        QuickAlert.show(
          context: context,
          type: QuickAlertType.custom,
          barrierDismissible: true,
          confirmBtnText: '確認修改',
          cancelBtnText: '取消',
          title: '修改個人資料',
          confirmBtnColor: Colors.green,
          widget: TextFormField(
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              hintText: '請輸入新資料',
            ),
            initialValue: orginalData,
            textInputAction: TextInputAction.next,
            onChanged: (value) => message = value,
          ),
          onConfirmBtnTap: () async {
            if (message.length < 1) {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Please input something',
              );
              return;
            }
            if (message == orginalData) {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                text: '請重新輸入!',
                confirmBtnText: '確認',
                title: '該不能與原資料相同!',
                confirmBtnColor: Colors.green,
              );
              return;
            }
            _handlePressed(message);
            Navigator.pop(context);
            await Future.delayed(const Duration(milliseconds: 1000));
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: "'$message' has been saved!.",
            );
          },
          onCancelBtnTap: (){
            Navigator.pop(context);
          },
        );
      },
      icon: Icon(Icons.keyboard_arrow_right, color: Colors.green,),
    );
  }
}