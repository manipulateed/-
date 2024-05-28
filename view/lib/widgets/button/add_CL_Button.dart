import 'package:flutter/material.dart';
import 'package:view/constants/button_style.dart';
import 'package:quickalert/quickalert.dart';

class AddCLButton {
  static String message = '';

  List<String> CL = [];
  dynamic Function(List<String>) onUpdateCL;

  AddCLButton({
    required this.CL,
    required this.onUpdateCL,
  });

  void _handlePressed(String newCL) {
    CL.add(newCL);
    onUpdateCL(CL);
  }

  IconButton getButton(context){
    return  IconButton(
      style: UI_ButtonStyle.add_CL_ButtonStyle,
      onPressed: () async{
        QuickAlert.show(
          context: context,
          type: QuickAlertType.custom,
          barrierDismissible: true,
          confirmBtnText: '確認新增',
          title: '新增收藏清單',
          confirmBtnColor: Colors.green,
          widget: TextFormField(
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              hintText: '請輸入名稱',
            ),
            textInputAction: TextInputAction.next,
            onChanged: (value) => message = value,
          ),
          onConfirmBtnTap: () async {
            if (message.length < 5) {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Please input something',
              );
              return;
            }
            if (CL.contains(message)) {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                text: '該名稱已存在!',
                confirmBtnText: '確認',
                title: '該名稱已存在!',
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
              text: "Phone number '$message' has been saved!.",
            );
          },
        );
      },
      icon: Icon(Icons.add),
    );
  }
}