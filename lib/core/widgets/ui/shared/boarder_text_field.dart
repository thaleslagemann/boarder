import 'package:flutter/material.dart';

enum Pattern { primary, secondary, outline, text, login }

class BoarderTextField extends StatefulWidget {
  BoarderTextField(
    this.text, {
    super.key,
    required this.controller,
    this.focusNode,
    this.undoController,
    this.border,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.style = BorderStyle.none,
    this.width,
    this.strokeAlign,
    this.borderRadius,
    this.textStyle,
    this.inputDecoration,
    this.obscureText = false,
    this.obscuringCharacter = "•",
    this.maxLines = 1,
    this.cursorColor = Colors.black,
    this.showCursor = true,
    this.hintText,
    this.hintColor,
    this.onChange,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.enabled = true,
    this.selectionColor,
    this.selectionHandleColor,
    this.textAlign,
    this.keyboardType,
  });

  final String text;
  final FocusNode? focusNode;
  Color? color = Colors.white;
  Color? backgroundColor = Colors.white;
  Color? borderColor = Colors.white;
  BoxBorder? border;
  double? borderRadius;
  BorderStyle style;
  double? width;
  double? strokeAlign;
  TextStyle? textStyle;
  InputDecoration? inputDecoration;
  bool obscureText;
  String obscuringCharacter;
  int maxLines;
  Color cursorColor;
  bool showCursor;
  String? hintText;
  Color? hintColor;
  bool textFieldFocused = false;
  bool enabled;
  Color? selectionColor;
  Color? selectionHandleColor;
  Function(String)? onChange;
  Function()? onEditingComplete;
  Function(String)? onFieldSubmitted;
  TextAlign? textAlign;
  TextInputType? keyboardType;

  RegExp pattern = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final TextEditingController controller;
  UndoHistoryController? undoController;

  @override
  State<BoarderTextField> createState() => _BoarderTextFieldState();
}

class _BoarderTextFieldState extends State<BoarderTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.border ??
            Border.all(
              style: widget.style,
              color: widget.borderColor ?? Colors.white,
              width: widget.width ?? 1.0,
              strokeAlign: widget.strokeAlign ?? BorderSide.strokeAlignInside,
            ),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 15.0),
        color: widget.backgroundColor,
      ),
      child: Theme(
        data: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: widget.cursorColor,
            selectionColor: widget.selectionColor,
          ),
        ),
        child: TextFormField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          undoController: widget.undoController,
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter,
          enabled: widget.enabled,
          textAlign: widget.textAlign ?? TextAlign.start,
          decoration: widget.inputDecoration ??
              InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: widget.hintColor ?? Colors.grey),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                border: InputBorder.none,
              ),
          keyboardType: widget.keyboardType,
          enableInteractiveSelection: true,
          magnifierConfiguration: TextMagnifierConfiguration(
            shouldDisplayHandlesInMagnifier: false,
          ),
          style: widget.textStyle ?? TextStyle(color: Colors.black),
          maxLines: widget.maxLines,
          showCursor: widget.showCursor,
          onChanged: (value) => widget.onChange,
          onEditingComplete: () => widget.onEditingComplete,
          onFieldSubmitted: (value) => widget.onFieldSubmitted,
        ),
      ),
    );
  }
}
