import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

import '../shared/shared.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: cubit.newTasks.isNotEmpty,
          builder: (BuildContext context) => ListView.separated(
            itemCount: cubit.newTasks.length,
            separatorBuilder: (_, l) => const Padding(
              padding: EdgeInsets.all(5.0),
              child: Divider(
                thickness: 0.5,
                color: Colors.black45,
                height: 5,
                indent: 15,
                endIndent: 15,
              ),
            ),
            itemBuilder: (_, index) => buildContainer(
                title: cubit.newTasks[index]['title'],
                date: cubit.newTasks[index]['date'],
                time: cubit.newTasks[index]['time'],
                id: cubit.newTasks[index]['id'],
                ctx: context),
          ),
          fallback: (BuildContext context) => const Center(
            child: Text(
              "No new tasks, Please add some",
              style: TextStyle(

              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget buildContainer(
      {required String title,
      required String date,
      required String time,
      required BuildContext ctx,
      required int id}) {
    return Dismissible(
      key: Key("$id"),
      onDismissed: (_){
        AppCubit.get(ctx).deleteFromDB(id);
      },
      background: buildBackgroundContainer(),
      secondaryBackground: buildSecondaryContainer(),
      confirmDismiss: (_)=> promptUser(ctx),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      title,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          Text(
                            date,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            time,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(ctx).updateDB(id: id, status: "done");
              },
              icon: const Icon(
                Icons.fact_check_outlined,
                color: Colors.green,
              ),
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(ctx).updateDB(id: id, status: "archived");
                },
                icon: const Icon(
                  Icons.archive_outlined,
                  color: Color.fromRGBO(118, 17, 10, 1),
                ))
          ],
        ),
      ),
    );
  }



}
