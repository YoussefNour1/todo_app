import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/shared/shared.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return
    BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return
        ConditionalBuilder(
          condition:cubit.doneTasks.isNotEmpty ,
          builder: (context) => ListView.separated(
            itemCount: cubit.doneTasks.length,
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
                title: cubit.doneTasks[index]['title'],
                date: cubit.doneTasks[index]['date'],
                time: cubit.doneTasks[index]['time'],
                id: cubit.doneTasks[index]['id'],
                ctx: context,
                cubit:cubit
            ),
          ) ,
          fallback: (context) =>const Center(child: Text("No done tasks here, finish some 😒"),),
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
        required int id,
        required AppCubit cubit,}) {
    return Dismissible(
      key: Key("$id"),
      onDismissed: (_){
        cubit.deleteFromDB(id);
      },
      confirmDismiss: (_)=>promptUser(ctx),
      background: buildBackgroundContainer(),
      secondaryBackground: buildSecondaryContainer(),
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
