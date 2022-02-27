import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';

import 'package:todo_app/cubit/cubit.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  DateTime? finalDate;

  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  TimeOfDay? finalTime;

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {
          if (state is InsertToDBState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, Object? state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.indigo,
              title: Text(cubit.title[cubit.index]),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              centerTitle: true,
            ),
            floatingActionButton: Builder(builder: (ctx) {
              return FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottom && titleController.text.isNotEmpty) {
                    cubit.createDatabase();
                    cubit
                        .insertInDB(
                            title: titleController.text,
                            date: dateController.text,
                            time: finalTime!.format(context).toString())
                        .then((value) {
                      cubit.isBottom = false;
                      cubit.changeIcon(Icons.add);
                      dateController.text = '';
                      finalDate = null;
                      titleController.text = '';
                      timeController.text = '';
                      finalTime = null;
                    });
                  } else if (cubit.isBottom) {
                    Navigator.pop(context);
                    cubit.isBottom = false;
                    cubit.changeIcon(Icons.add);
                    dateController.text = '';
                    finalDate = null;
                    titleController.text = '';
                    timeController.text = '';
                    finalTime = null;
                  } else {
                    cubit.isBottom = true;
                    cubit.changeIcon(Icons.done_outline);
                    Scaffold.of(ctx)
                        .showBottomSheet(
                          (_) => Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Add New Task",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                          label: const Text("Title"),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      readOnly: true,

                                      onTap: () async {
                                        var date = await showDatePicker(
                                          context: context,
                                          initialDate: finalDate == null
                                              ? DateTime.now()
                                              : finalDate!,
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime(DateTime.now().year + 5),
                                        );

                                        if (date != null) {
                                          finalDate = date;
                                          dateController.text =
                                              date.toString().split(' ')[0];
                                        }
                                      },
                                      controller: dateController,
                                      decoration: InputDecoration(
                                          label: const Text("Date"),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      onTap: () async {
                                        var time = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              const TimeOfDay(hour: 8, minute: 0),
                                        );

                                        if (time != null) {
                                          finalTime = time;
                                          timeController.text =
                                              time.format(context).toString();
                                        }
                                      },
                                      controller: timeController,
                                      decoration: InputDecoration(
                                          label: const Text("Time"),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                          ),
                          backgroundColor: Colors.grey[200],
                          elevation: 10,
                        )
                        .closed
                        .then((value) {
                      AppCubit.get(context).isBottom = false;
                      cubit.changeIcon(Icons.add);
                    });
                  }
                },
                child: Icon(cubit.icon),
                backgroundColor: Colors.indigo,
                tooltip: "New Task",
              );
            }),
            bottomNavigationBar: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30) )
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        cubit.changeBottomNav(0);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.task_alt, color: cubit.index == 0?cubit.color: Colors.black45,),
                          Text("Tasks",style: TextStyle(
                            color: cubit.index == 0?cubit.color: Colors.black45,
                          ),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        cubit.changeBottomNav(1);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.done, color: cubit.index == 1?cubit.color: Colors.black45,),
                          Text("Done",style: TextStyle(
                            color: cubit.index == 1?cubit.color: Colors.black45,
                          ),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        cubit.changeBottomNav(2);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.archive, color: cubit.index == 2?cubit.color: Colors.black45,),
                          Text("Archive",style: TextStyle(
                            color: cubit.index == 2?cubit.color: Colors.black45,
                          ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! ProgressInd,
              builder: (BuildContext context) => cubit.screens[cubit.index],
              fallback: (BuildContext context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
  BottomNavigationBar bottomNav(AppCubit cubit)=>BottomNavigationBar(
    backgroundColor: Colors.indigo,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.add_task_sharp),
        label: "Tasks",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
      BottomNavigationBarItem(
          icon: Icon(Icons.archive), label: "Archive"),
    ],
    onTap: (value) {
      cubit.changeBottomNav(value);
    },
    currentIndex: cubit.index,
    elevation: 15,
    selectedItemColor: Colors.white,
  );
}
