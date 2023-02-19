import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:crafts_men/pages/worker/worker_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class SendReplay extends StatefulWidget {
  String userUid;
  String userRequest;
  static const routeName = '/sendReplay';
  SendReplay({
    required this.userUid,
    required this.userRequest,
  });

  @override
  State<SendReplay> createState() => _SendReplayState();
}

class _SendReplayState extends State<SendReplay> {
  var priceController = TextEditingController();
  var replayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var maxLines = 5;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text('الرد على الشكوى'),
          ),
          body: Padding(
            padding: EdgeInsets.only(
              top: 10.h,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 10.w),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 70.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/logo.jpg'),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepPurple, width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'اجمالى السعر',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: replayController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepPurple, width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'الوقت المتاح',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: double.infinity, height: 65.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                        ),
                        onPressed: () async {
                          String price =
                              priceController.text.trim();
                          String replay =
                              replayController.text.trim();

                          if (price.isEmpty) {
                            CherryToast.info(
                              title: Text('ادخل اجمالى السعر'),
                              actionHandler: () {},
                            ).show(context);
                            return;
                          }

                          if (replay.isEmpty) {
                            CherryToast.info(
                              title: Text('ادخل الوقت المتاح'),
                              actionHandler: () {},
                            ).show(context);
                            return;
                          }

                          User? user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            String uid = user.uid;
                            int date = DateTime.now().millisecondsSinceEpoch;

                            DatabaseReference companyRef = FirebaseDatabase
                                .instance
                                .reference()
                                .child('workerReplays');

                            String? id = companyRef.push().key;

                            await companyRef.child(id!).set({
                              'id': id,
                              'userUid': widget.userUid,
                              'userRequest': widget.userRequest,
                              'price': price,
                              'adminReplay': replay,
                            });
                          }
                          showAlertDialog(context);
                        },
                        child: Text('ارسال الرد'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    style: TextButton.styleFrom(
      primary: HexColor('#6bbcba'),
    ),
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, WorkerHome.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text('تم ارسال الرد'),
    actions: [
      remindButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
