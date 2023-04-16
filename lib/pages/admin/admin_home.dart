import 'package:crafts_men/pages/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/complains_model.dart';
import '../models/craftsmen_model.dart';
import 'add_craftsmen.dart';
import 'admin_replay.dart';

class AdminHome extends StatefulWidget {
  static const routeName = '/adminHome';
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<CraftsMenV> menList = [];
  List<CraftsMenV> searchList = [];
  List<String> keyslist = [];
  List<CraftsMenV> menList2 = [];
  List<String> keyslist3 = [];
  List<Complains> complainsList = [];
  List<String> keyslist2 = [];
  String dropdownValue = 'سباكة';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTypes();
    fetchCraftsMen();
    fetchComplains();
  }

  void fetchComplains() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("userComplains");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Complains p = Complains.fromJson(event.snapshot.value);
      complainsList.add(p);
      keyslist2.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  void fetchTypes() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("craftsMen").child('U9OA7dGjutfudeZD21ZhfkfRucD2');
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      CraftsMenV p = CraftsMenV.fromJson(event.snapshot.value);
      menList2.add(p);
      keyslist3.add(event.snapshot.key.toString());
      print(keyslist2);
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
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        controller: tabController,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        labelPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                        isScrollable: true,
                        tabs: const [
                          Tab(
                            child: Text('اصحاب الحرف',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Tab(
                            child: Text('الشكاوى',
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
                    padding: const EdgeInsets.all(8.0),
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
                          height: 20.h,
                        ),
                        ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: double.infinity, height: 50.h),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromARGB(255, 211, 211, 211),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(25), // <-- Radius
                                ),
                              ),
                              child: Text(
                                'أضافة اصحاب الحرف',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AddCraftsMen();
                                }));
                              },
                            )),
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
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        '${menList[index].email.toString()}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'كلمة المرور : ${menList[index].password.toString()}',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'الهاتف : ${menList[index].phoneNumber.toString()}',
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget));
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child('craftsMen')
                                            .child('${menList[index].uid}')
                                            .remove();
                                      },
                                      child: Icon(Icons.delete,
                                          color: Color.fromARGB(
                                              255, 122, 122, 122)),
                                    )
                                  ]),
                                );
                              },
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      3, index.isEven ? 3 : 3),
                              mainAxisSpacing: 40.0,
                              crossAxisSpacing: 5.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15.h,
                      right: 10.w,
                      left: 10.w,
                    ),
                    child: ListView.builder(
                      itemCount: complainsList.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                      top: 10, right: 15, left: 15, bottom: 10),
                                  child: Column(children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'الشكوى : ${complainsList[index].description.toString()}',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'كود المشتكى: ${complainsList[index].userUid.toString()}',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              width: 120.w, height: 35.h),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.deepPurple,
                                            ),
                                            child: Text('الرد على الشكوى'),
                                            onPressed: () async {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return AdminReplay(
                                                  complain:
                                                      '${complainsList[index].description.toString()}',
                                                  uid:
                                                      '${complainsList[index].userUid.toString()}',
                                                );
                                              }));
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              width: 120.w, height: 35.h),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.deepPurple,
                                            ),
                                            child: Text('مسح الشكوى'),
                                            onPressed: () async {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          super.widget));
                                              base
                                                  .child(complainsList[index]
                                                      .id
                                                      .toString())
                                                  .remove();
                                            },
                                          ),
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
                      },
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
