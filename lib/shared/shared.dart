import 'package:flutter/material.dart';

Future<bool> promptUser(BuildContext context) async {
  String action = "delete";
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          const Icon(Icons.warning, color: Color.fromARGB(255, 173, 6, 6),),
          const SizedBox(width: 10,),
          Text("Are you sure you want to $action?"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            return Navigator.of(context).pop(false);
          },)
      ],
    ),
  ) ??
      false;
}

Container buildBackgroundContainer() {
  return Container(
    child: const Icon(Icons.delete, color: Colors.white,),
    alignment: AlignmentDirectional.centerStart,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
  );
}

Container buildSecondaryContainer() {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      alignment: AlignmentDirectional.centerEnd,
      child: const Icon(Icons.delete, color: Colors.white,));
}