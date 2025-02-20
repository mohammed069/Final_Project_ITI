import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key, required this.leading, required this.title, required this.trailing, required this.onTap});

  final Icon leading;
  final String title;
  final Icon trailing;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: onTap,
      child: ListTile(
        leading: leading,
        title: Text(title),
        trailing: trailing,
      ),
    );
  }
}
