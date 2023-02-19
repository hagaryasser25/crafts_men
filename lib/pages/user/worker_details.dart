import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/craftsmen_model.dart';
import '../models/workers_model.dart';
import 'make-request.dart';

class WorkerDetails extends StatefulWidget {
  String workerUid;
  String type;
  WorkerDetails({required this.workerUid, required this.type});

  @override
  State<WorkerDetails> createState() => _WorkerDetailsState();
}

class _WorkerDetailsState extends State<WorkerDetails> {
  String dropdownValue = 'سباكة';
  late TabController tabController;
  late DatabaseReference base, base2;
  late FirebaseDatabase database, database2;
  late FirebaseApp app, app2;
  List<CraftsMenV> menList = [];
  List<String> keyslist3 = [];
  List<Workers> workersList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchWorkers();
  }



  @override
  void fetchWorkers() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("services").child("${widget.type}");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Workers p = Workers.fromJson(event.snapshot.value);
      workersList.add(p);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.deepPurple, title: Text('سابق الأعمال')),
          body: Padding(
            padding: EdgeInsets.only(
              right: 5.w,
              left: 5.w,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Expanded(
                  flex: 8,
                  child: FutureBuilder(
                    builder: ((context, snapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: workersList.length,
                          itemBuilder: ((context, index) {
                            if (widget.workerUid == workersList[index].uid) {
                              return Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 170.w,
                                              height: 170.h,
                                              child: Image.network(
                                                  '${workersList[index].serviceImage.toString()}'),
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10.w),
                                                  child: Text(
                                                      'اسم الخدمة : ${workersList[index].serviceName.toString()}',
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10.w),
                                                  child: Text(
                                                      'سعر الخدمة : ${workersList[index].servicePrice.toString()}',
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                ConstrainedBox(
                                                  constraints:
                                                      BoxConstraints.tightFor(
                                                          width: 90.w,
                                                          height: 40.h),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Colors.deepPurple,
                                                    ),
                                                    child: Text('عمل طلب'),
                                                    onPressed: () async {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return MakeRequest(
                                                          workerUid:
                                                              workersList[index]
                                                                  .uid
                                                                  .toString(),
                                                        );
                                                      }));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Text('');
                            }
                          }));
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
