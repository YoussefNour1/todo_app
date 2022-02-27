import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';
import '../modules/archived_tasks.dart';
import '../modules/done_tasks.dart';
import '../modules/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int index = 0;
  bool isBottom = false;
  IconData icon = Icons.add;
  List screens = [const NewTasks(), const DoneTasks(), const ArchivedTasks()];
  List title = ["New Tasks", "Done Tasks", "Archived Tasks"];
  Color color = Colors.white;

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeBottomNav(int index) {
    this.index = index;
    emit(ChangeBottomNavBar());
  }

  void changeIcon(IconData ic) {
    icon = ic;
    emit(ChangeState());
  }

  createDatabase() async {
    try {
      openDatabase("tasks.db", version: 1, onCreate: (database, version) {
        database.execute(
            "create table tasks (id INTEGER primary key, title TEXT, date TEXT, time TEXT, status Text)");
        print("Database created");
      }, onOpen: (db) {
        print("database opened");
        database = db;
        getData();
      }).then((value) {
        emit(CreateDBState());
      }).catchError((e) {
        print(e.toString());
      });
    } catch (e, s) {
      print(s);
    }
  }

  insertInDB({
    required String title,
    required String date,
    required String time,
  }) async {
    await database!.transaction((txn) {
      txn
          .rawInsert(
              'insert into tasks(title, date, time, status) values ("$title", "$date", "$time", "new")')
          .then((value) {
        print(value);
        emit(InsertToDBState());
        getData();
      }).catchError((e) {
        print(e.toString());
      });
      Future x = Future(
        () {},
      );
      return x;
    });
  }

  void updateDB({required int id, required String status}){
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getData();
      emit(UpdateDBState());
    });
  }

  void getData() async {
    emit(ProgressInd());
    newTasks.clear();
    doneTasks.clear();
    archivedTasks.clear();
    await database!
        .rawQuery("select * from tasks")
        .then((value) {
      value.forEach((element) {
        print(element["status"]);
        if(element['status'] == "new"){
          newTasks.add(element);
        }
        else if(element['status'] == "done"){
          doneTasks.add(element);
        }
        else{
          archivedTasks.add(element);
        }
      });
      print(value);
      emit(GetFromDB());
    });
  }

  void deleteFromDB(int id){
    database!.rawDelete('DELETE FROM tasks WHERE id = ?' , [id]).then((value){
      getData();
      emit(DeleteDBState());
    });
  }
}
