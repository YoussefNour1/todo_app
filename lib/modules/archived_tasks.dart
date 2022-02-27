import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return ConditionalBuilder(
          builder: (_)=> ListView.separated(
            itemCount: cubit.archivedTasks.length,
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
                title: cubit.archivedTasks[index]['title'],
                date: cubit.archivedTasks[index]['date'],
                time: cubit.archivedTasks[index]['time'],
                id: cubit.archivedTasks[index]['id'],
                ctx: context
            ),
          ),
          condition: cubit.archivedTasks.isNotEmpty ,
          fallback: (context) =>const Center(child: Text("No archived tasks here"),),
        );
      },
      listener: (context, state) {},
    );
  }

  Container buildContainer(
      {required String title,
        required String date,
        required String time,
        required BuildContext ctx,
        required int id}) {
    return Container(
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
                AppCubit.get(ctx).deleteFromDB(id);
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.black,
              ))
        ],
      ),
    );
  }
}