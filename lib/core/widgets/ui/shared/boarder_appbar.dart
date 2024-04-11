import 'package:flutter/material.dart';

class BoarderAppbar extends StatelessWidget implements PreferredSizeWidget {
  BoarderAppbar(
    this.title, {
    super.key,
    this.titleColor,
    this.backgroundColor,
    this.leadingIcon,
    this.iconColor,
    this.elevation,
    this.shadowColor,
    this.actions,
  });

  String? title;
  Color? titleColor;
  Icon? leadingIcon;
  Color? iconColor;
  Color? backgroundColor;
  double? elevation;
  Color? shadowColor;
  List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          title ?? '',
          style: TextStyle(color: titleColor ?? Colors.black),
        ),
      ),
      elevation: elevation ?? 4,
      shadowColor: shadowColor ?? Colors.black,
      leading: IconButton(
        icon: leadingIcon ?? Icon(Icons.menu),
        color: iconColor ?? Colors.black,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      actions: actions ??
          [
            SizedBox(
              width: 40,
            )
          ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
