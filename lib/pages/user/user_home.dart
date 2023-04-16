import 'package:crafts_men/pages/auth/login_screen.dart';
import 'package:crafts_men/pages/models/workerreplay_model.dart';
import 'package:crafts_men/pages/user/send_complain.dart';
import 'package:crafts_men/pages/user/user_replays.dart';
import 'package:crafts_men/pages/user/worker_details.dart';
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

class UserHome extends StatefulWidget {
  static const routeName = '/userHome';
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<CraftsMenV> menList = [];
  List<CraftsMenV> searchList = [];
  List<WorkerReplays> replaysList = [];
  List<CraftsMenV> menList2 = [];
  List<String> keyslist = [];
  List<String> keyslist2 = [];
  List<String> keyslist3 = [];
  String dropdownValue = 'سباكة';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTypes();
    fetchCraftsMen();
    fetchReplays();
  }

  void fetchTypes() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("craftsMen");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      CraftsMenV p = CraftsMenV.fromJson(event.snapshot.value);
      menList2.add(p);
      keyslist2.add(event.snapshot.key.toString());
      print(keyslist2);
      setState(() {});
    });
  }

  void fetchReplays() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("workerReplays");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      WorkerReplays p = WorkerReplays.fromJson(event.snapshot.value);
      replaysList.add(p);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  void fetchCraftsMen() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("craftsMen");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      CraftsMenV p = CraftsMenV.fromJson(event.snapshot.value);
      menList.add(p);
      searchList.add(p);
      keyslist.add(event.snapshot.key.toString());
      print(keyslist);
      setState(() {});
    });
  }

  @override
  void initState() {
    tabController = TabController(
      length: 4,
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
                            child: Text('الخدمات',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Tab(
                            child: Text('الشكاوى',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Tab(
                            child: Text('الردود على الطلبات',
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
                  Padding(
                    padding: EdgeInsets.only(
                      right: 5.w,
                      left: 5.w,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'بحث عن حرفة',
                          ),
                          onChanged: (char) {
                            setState(() {
                              if (char.isEmpty) {
                                setState(() {
                                  menList = searchList;
                                });
                              } else {
                                menList = [];
                                for (CraftsMenV model in searchList) {
                                  if (model.type!.contains(char)) {
                                    menList.add(model);
                                  }
                                }
                                setState(() {});
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: StaggeredGridView.countBuilder(
                              padding: EdgeInsets.only(
                                top: 20.h,
                                left: 15.w,
                                right: 15.w,
                                bottom: 15.h,
                              ),
                              crossAxisCount: 6,
                              itemCount: menList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 10.h,
                                      ),
                                      child: CircleAvatar(
                                        radius: 37,
                                        backgroundImage: NetworkImage(
                                            '${menList[index].imageUrl.toString()}'),
                                      ),
                                    ),
                                    Text(
                                      '${menList[index].name.toString()}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                        '${menList[index].phoneNumber.toString()}'),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    RatingBar.builder(
                                      initialRating:
                                          menList[index].rating!.toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (double rating2) async {
                                        rating2.toDouble();
                                        User? user =
                                            FirebaseAuth.instance.currentUser;

                                        if (user != null) {
                                          DatabaseReference companyRef =
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child('craftsMen')
                                                  .child(menList[index]
                                                      .uid
                                                      .toString());

                                          await companyRef.update({
                                            'rating': rating2,
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: 120.w, height: 40.h),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.deepPurple,
                                        ),
                                        child: Text('سابق الأعمال'),
                                        onPressed: () async {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return WorkerDetails(
                                              workerUid:
                                                  menList[index].uid.toString(),
                                            );
                                          }));
                                        },
                                      ),
                                    ),
                                  ]),
                                );
                              },
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      3, index.isEven ? 3 : 3),
                              mainAxisSpacing: 35.0,
                              crossAxisSpacing: 5.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                          'أختر القسم',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10.h, right: 10.w, left: 10.w),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, SendComplain.routeName);
                                    },
                                    child: card(
                                      'ارسال شكوى',
                                    )),
                                SizedBox(
                                  width: 10.w,
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, UserReplays.routeName);
                                    },
                                    child: card(
                                      'الردود على الشكاوى',
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15.h,
                      right: 10.w,
                      left: 10.w,
                    ),
                    child: FutureBuilder(
                      builder: ((context, snapshot) {
                        return ListView.builder(
                          itemCount: replaysList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (FirebaseAuth.instance.currentUser!.uid ==
                                replaysList[index].userUid) {
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
                                                'الطلب : ${replaysList[index].userRequest.toString()}',
                                                style: TextStyle(fontSize: 17),
                                              )),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'اجمالى السعر : ${replaysList[index].price.toString()}',
                                                style: TextStyle(fontSize: 17),
                                              )),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'الوقت المتاح : ${replaysList[index].adminReplay.toString()}',
                                                style: TextStyle(fontSize: 17),
                                              )),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: 120.w, height: 35.h),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.deepPurple,
                                              ),
                                              child: Text('مسح الطلب'),
                                              onPressed: () async {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            super.widget));
                                                base
                                                    .child(replaysList[index]
                                                        .id
                                                        .toString())
                                                    .remove();
                                              },
                                            ),
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
                  ),
                ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

Widget card(String text) {
  return Container(
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: 150.w,
        height: 250.h,
        child: Center(
            child: Text(text,
                style: TextStyle(fontSize: 18, color: Colors.deepPurple))),
      ),
    ),
  );
}
