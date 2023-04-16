import 'package:crafts_men/pages/auth/login_screen.dart';
import 'package:crafts_men/pages/models/requests_model.dart';
import 'package:crafts_men/pages/models/workers_model.dart';
import 'package:crafts_men/pages/worker/add_service.dart';
import 'package:crafts_men/pages/worker/send_replay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/craftsmen_model.dart';

class WorkerHome extends StatefulWidget {
  static const routeName = '/workerHome';
  const WorkerHome({super.key});

  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late DatabaseReference base, base2;
  late FirebaseDatabase database, database2;
  late FirebaseApp app, app2;
  List<CraftsMenV> menList = [];
  List<String> keyslist3 = [];
  List<Workers> workersList = [];
  List<String> keyslist = [];
  List<Requests> requestsList = [];
  List<String> keyslist2 = [];
  String dropdownValue = 'سباكة';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchRequests();
    fetchWorkers();
    fetchCraftsMen();
  }

  void fetchCraftsMen() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("craftsMen");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      CraftsMenV p = CraftsMenV.fromJson(event.snapshot.value);
      menList.add(p);
      keyslist3.add(event.snapshot.key.toString());
      print(keyslist3);
      setState(() {});
    });
  }

  void fetchWorkers() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("services").child(FirebaseAuth.instance.currentUser!.uid);
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Workers p = Workers.fromJson(event.snapshot.value);
      workersList.add(p);
      print(FirebaseAuth.instance.currentUser!.uid);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  void fetchRequests() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("requests");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Requests p = Requests.fromJson(event.snapshot.value);
      requestsList.add(p);
      print(FirebaseAuth.instance.currentUser!.uid);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  @override
  void initState() {
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: 220.h,
                  color: Colors.deepPurple,
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TabBar(
                        controller: tabController,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        labelPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                        isScrollable: true,
                        tabs: [
                          Tab(
                            child: Text('سابق الأعمال',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Tab(
                            child: Text('الطلبات',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Tab(
                            child: Text('تسجيل الخروج',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ]),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 580.h,
                child: TabBarView(controller: tabController, children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: 220.w, height: 50.h),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 211, 211, 211),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25), // <-- Radius
                              ),
                            ),
                            child: Text(
                             'أضافة سابقة الأعمال',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AddService();
                              }));
                            },
                          )),
                      Expanded(
                        flex: 8,
                        child: FutureBuilder(
                          builder: ((context, snapshot) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: workersList.length,
                                itemBuilder: ((context, index) {
                                  
                                    return Column(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
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
                                                        padding:
                                                            EdgeInsets.only(
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10.w),
                                                        child: Text(
                                                            'سعر الخدمة : ${workersList[index].servicePrice.toString()}',
                                                            style: TextStyle(
                                                                fontSize: 15)),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      super
                                                                          .widget));
                                                          FirebaseDatabase
                                                              .instance
                                                              .reference()
                                                              .child('services')
                                                              .child(
                                                                  FirebaseAuth.instance.currentUser!.uid)
                                                              .child(
                                                                  '${workersList[index].id}')
                                                              .remove();
                                                        },
                                                        child: Icon(
                                                            Icons.delete,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    122,
                                                                    122,
                                                                    122)),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  
                                }));
                          }),
                        ),
                      ),
                     
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10.w,
                      left: 10.w,
                    ),
                    child: FutureBuilder(
                      builder: ((context, snapshot) {
                        return ListView.builder(
                          itemCount: requestsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (FirebaseAuth.instance.currentUser!.uid ==
                                requestsList[index].workerUid) {
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
                                            top: 10,
                                            right: 15,
                                            left: 15,
                                            bottom: 10),
                                        child: Column(children: [
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'اسم صاحب الطلب: ${requestsList[index].userName.toString()}',
                                                style: TextStyle(fontSize: 17),
                                              )),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'رقم الهاتف: ${requestsList[index].userPhone.toString()}',
                                                style: TextStyle(fontSize: 17),
                                              )),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'تفاصيل الخدمة : ${requestsList[index].description.toString()}',
                                                style: TextStyle(fontSize: 17),
                                              )),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'تاريخ التنفيذ : ${requestsList[index].date.toString()}',
                                                style: TextStyle(fontSize: 17),
                                              )),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              ConstrainedBox(
                                                constraints:
                                                    BoxConstraints.tightFor(
                                                        width: 80.w,
                                                        height: 40.h),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.deepPurple,
                                                  ),
                                                  child: Text('الرد'),
                                                  onPressed: () async {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return SendReplay(
                                                        userUid:
                                                            '${requestsList[index].userUid.toString()}',
                                                        userRequest:
                                                            '${requestsList[index].description.toString()}',
                                                      );
                                                    }));
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 140.w,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                  base
                                                      .child(requestsList[index]
                                                          .id
                                                          .toString())
                                                      .remove();
                                                },
                                                child: Icon(Icons.delete,
                                                    color: Color.fromARGB(
                                                        255, 122, 122, 122)),
                                              ),
                                            ],
                                          )
                                        ]),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  )
                                ],
                              );
                            } else {
                              return Text('');
                            }
                          },
                        );
                      }),
                    ),
                  ),
                  Column(
                    children: [
                      Image.asset('assets/images/logout.jfif',
                          height: 400.h, width: double.infinity),
                      SizedBox(
                        height: 50.h,
                      ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 120.w, height: 40.h),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                          ),
                          child: Text('تسجيل الخروج'),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('تأكيد'),
                                    content:
                                        Text('هل انت متأكد من تسجيل الخروج'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.pushNamed(
                                              context, LoginPage.routeName);
                                        },
                                        child: Text('نعم'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('لا'),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  )
                ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
