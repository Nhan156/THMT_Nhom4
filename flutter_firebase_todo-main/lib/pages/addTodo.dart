// ignore_for_file: file_names, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String type = "";
  String category = "";
  DateTime selectedDateTime = DateTime.now(); // Initialize with current date and time

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff1d1e26),
          Color(0xff252041),
        ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "New Todo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    label("Tiêu đề nhiệm vụ"),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 10,
                    ),
                    label("Loại nhiệm vụ"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        taskSelect("Quan trọng", 0xff2664fa),
                        SizedBox(
                          width: 15,
                        ),
                        taskSelect("Kế hoạch", 0xff2bc8d9),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Button to open date and time picker
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                          );

                          if (selectedTime != null) {
                            setState(() {
                              selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text("Pick Date and Time"),
                    ),

                    label("Miêu tả"),
                    SizedBox(
                      height: 10,
                    ),
                    description(),
                    SizedBox(
                      height: 15,
                    ),
                    label("Loại"),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: [
                        categorySelect("Việc lặt vặt", 0xffff6d6e),
                        SizedBox(
                          width: 15,
                        ),
                        categorySelect("Công việc nhà", 0xfff29732),
                        SizedBox(
                          width: 15,
                        ),
                        categorySelect("Cửa hàng tạp hóa", 0xff6557ff),
                        SizedBox(
                          width: 15,
                        ),
                        categorySelect("GYM", 0xff2bc8d9),
                        SizedBox(
                          width: 15,
                        ),
                        categorySelect("Công việc", 0xff663300),
                        SizedBox(
                          width: 15,
                        ),
                        categorySelect("Trường học", 0xff009900),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    createButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          type = label;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: type == label ? Colors.white : Color(color),
        label: Text(
          label,
          style: TextStyle(
              color: type == label ? Colors.black : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        labelPadding: EdgeInsets.symmetric(vertical: 3.8, horizontal: 13),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: category == label ? Colors.black : Color(color),
        label: Text(
          label,
          style: TextStyle(
              color: type == label ? Colors.white : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        labelPadding: EdgeInsets.symmetric(vertical: 3.8, horizontal: 13),
      ),
    );
  }

  Widget createButton() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Todo").add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'type': type,
          'category': category, // 42,
          'dateTime': selectedDateTime,
        });
        Navigator.pop(context);
      },
      child: Container(
          child: Center(
            child: Text(
              'Add Todo',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Color(0xffff9999),
              Color(0xffff5050),
              Color(0xffff4500),
            ]),
          )),
    );
  }

  Widget description() {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: null,
        style: TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
            hintText: "Description",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 8)),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
            hintText: "Task Title",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 5)),
      ),
    );
  }

  Widget label(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontSize: 16.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2),
    );
  }
}
