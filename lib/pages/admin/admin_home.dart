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

  @override
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
    base = database.reference().child("craftsMen");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      CraftsMenV p = CraftsMenV.fromJson(event.snapshot.value);
      menList2.add(p);
      keyslist3.add(event.snapshot.key.toString());
      print(keyslist2);
      setState(() {});
    });
  }

  @override
  void fetchCraftsMen() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("craftsMen").child("$dropdownValue");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      CraftsMenV p = CraftsMenV.fromJson(event.snapshot.value);
      menList.add(p);
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
                  Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.h, right: 15.w, left: 15.w),
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 183, 183, 183),
                                  width: 2.0),
                            ),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: SizedBox(),

                            // Step 3.
                            value: dropdownValue,
                            icon: Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(Icons.arrow_drop_down,
                                  color: Color.fromARGB(255, 119, 118, 118)),
                            ),

                            // Step 4.
                            items: keyslist3.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 5,
                                  ),
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 119, 118, 118)),
                                  ),
                                ),
                              );
                            }).toList(),
                            // Step 5.
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                                menList.clear();
                                fetchCraftsMen();
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 300,
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
                                Text('${menList[index].email.toString()}'),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text('${menList[index].password.toString()}'),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                    '${menList[index].phoneNumber.toString()}'),
                                InkWell(
                                  onTap: () async {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                super.widget));
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('craftsMen')
                                        .child('$dropdownValue')
                                        .child('${menList[index].id}')
                                        .remove();
                                  },
                                  child: Icon(Icons.delete,
                                      color:
                                          Color.fromARGB(255, 122, 122, 122)),
                                )
                              ]),
                            );
                          },
                          staggeredTileBuilder: (int index) =>
                              new StaggeredTile.count(3, index.isEven ? 3 : 3),
                          mainAxisSpacing: 30.0,
                          crossAxisSpacing: 5.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AddCraftsMen.routeName);
                              },
                              child: ClipPath(
                                clipper: StarClipper(10),
                                child: Container(
                                  color: Colors.deepPurple,
                                  height: 80,
                                  width: 80,
                                  child: Center(
                                      child:
                                          Icon(Icons.add, color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
