// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/custom/todoCard.dart';
import 'package:firebase_todo/pages/addTodo.dart';
import 'package:firebase_todo/pages/signin.dart';
import 'package:firebase_todo/pages/viewdata.dart';
import 'package:firebase_todo/service/google_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () async {
                authClass.logOut(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => SignInPage()),
                    (route) => false);
              },
            ),
          ],
          backgroundColor: Colors.black87,
          title: Text(
            "Danh Sách công việc",
            style: TextStyle(
                color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: Text(
                  'Hôm nay',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(35),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          items: [
            BottomNavigationBarItem(
                icon: Container(
                  height: 20,
                  width: 50,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Icon(
                    size: 32,
                    Icons.home,
                    color: Colors.white,
                  ),
                ),
                label: '',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => AddTodoPage()));
                  },
                  child: Container(
                    height: 50,
                    width: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffff9999),
                          Color(0xffff5050),
                          Color(0xffff4500),
                        ],
                      ),
                    ),
                    child: Icon(
                      size: 32,
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                label: '',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Container(
                  height: 20,
                  width: 50,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Icon(
                    size: 32,
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
                label: '',
                backgroundColor: Colors.red),
          ],
        ),
        body: StreamBuilder<dynamic>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: ((context, index) {
                IconData iconData = Icons.question_mark;
                Color iconColor = Colors.black;
                Map<String, dynamic> document =
                    snapshot.data.docs[index].data() as Map<String, dynamic>;
                switch (document["category"]) {
                  case "Công Việc":
                    iconData = Icons.work;

                    break;
                  case "Việc lặt vặt":
                    iconData = Icons.directions_walk_outlined;

                    break;
                  case "Công việc nhà":
                    iconData = Icons.house;

                    break;
                  case "Cửa hàng tạp hóa":
                    iconData = Icons.local_grocery_store;

                    break;
                  case "GYM":
                    iconData = Icons.fitness_center;

                    break;
                  case "Trường học":
                    iconData = Icons.school;

                    break;
                  default:
                    iconData = Icons.question_mark;
                    iconColor = Colors.white;
                }
                switch (document["type"]) {
                  case "Quan trọng":
                    iconColor = Colors.red;
                    break;
                  case "Kế hoạch":
                    iconColor = Colors.black;
                    break;

                  default:
                    iconColor = Colors.white;
                }
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ViewDataPage(
                          document: document,
                          id: snapshot.data.docs[index].id,
                        ),
                      ),
                    );
                  },
                  child: TodoCard(
                    title: document["title"] == null
                        ? "Title is Empty"
                        : document["title"],
                    check: true,
                    dateTime: document["dateTime"] != null ? (document["dateTime"] as Timestamp).toDate() : null,
                    iconBgColor: Colors.white,
                    iconColor: iconColor,
                    iconData: iconData,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}


/*TodoCard(
                title: "Wake Up",
                check: true,
                time: "11 PM",
                iconBgColor: Colors.white,
                iconColor: Colors.black,
                iconData: Icons.alarm,
              );*/

/*IconButton(
          icon: Icon(
            Icons.logout,
          ),
          onPressed: () async {
            authClass.logOut(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => SignInPage()),
                (route) => false);
          },
        ),*/
