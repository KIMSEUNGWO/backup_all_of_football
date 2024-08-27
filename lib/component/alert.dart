

import 'package:flutter/material.dart';

class Alert {

  Alert.privateConstructor();

  static _AlertBuilder of(BuildContext context) {
    return _AlertBuilder(context);
  }



}

class _AlertBuilder {

  final BuildContext context;

  _AlertBuilder(this.context);

  void confirm({required String message, required String btnMessage, required Function() onPressed, Function()? onCanceled}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            child: SizedBox(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Text(message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 45,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (onCanceled != null) {
                                  onCanceled();
                                }
                                Navigator.of(context).pop(false);
                              },
                              splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                              highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: alertBorderSide,
                                    right: alertBorderSide
                                  ),
                                ),
                                child: Center(
                                  child: Text('취소',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                onPressed();
                              },
                              splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                              highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: alertBorderSide
                                  ),
                                ),
                                child: Center(
                                  child: Text(btnMessage,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            )
        );
      },
    );
  }
  void message({required String message, VoidCallback? onPressed}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              child: Container(
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Text(message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                  if (onPressed != null) {
                                    onPressed();
                                  }
                                },
                                splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
                                highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(top: alertBorderSide,),
                                  ),
                                  child: Center(
                                    child: Text('확인',
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              )
          );
        },
        barrierDismissible: false
    );
  }
  static BorderSide alertBorderSide = const BorderSide(
      color: Colors.grey,
      width: 0.2
  );
}