import 'package:flutter/material.dart';
import 'package:view/constants/button_style.dart';
import 'package:quickalert/quickalert.dart';

class AddCLButton {
  static String message = '';

  List<Map<String, dynamic>> CL = [];
  dynamic Function(String) onUpdateCL;

  AddCLButton({
    required this.CL,
    required this.onUpdateCL,
  });

  void _handlePressed(String newName) {
    onUpdateCL(newName);
  }

  FloatingActionButton getButton(context) {
    return FloatingActionButton(
      onPressed: () async {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.custom,
          barrierDismissible: true,
          confirmBtnText: '確認新增',
          cancelBtnText: '取消',
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
            if (message.length < 1) {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: '請輸入有效名稱',
              );
              return;
            }
            if (CL.any((element) => element.containsKey(message))) {
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
            await Future.delayed(const Duration(milliseconds: 300));
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: "收藏清單 '$message' 已新增!",
            );
          },
          onCancelBtnTap: (){
            Navigator.pop(context);
          },
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.green[100],
    );
  }
}
