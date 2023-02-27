import 'package:flutter/material.dart';

import 'button_widget.dart';

///带清除按钮和密码显示的输入框
class NormalInputText extends StatefulWidget {
  static const TYPE_TEXT = 1;
  static const TYPE_PASS = 2;

  ///只显示右边的按钮，密码框时，显示密码。文本框时，显示清除按钮
  static const INPUT_STYLE_ONLY_RIGHT = 1;

  ///左边为显示密码按钮，右边为显示清除按钮
  static const INPUT_STYLE_LEFTPASS_RIGHTCLEAR = 2;

  final TextAlign textAlign;

  ///1-普通输入框  2-密码 ;
  final int? type;

  ///未输入时提示语
  final String? hintText;

  final TextEditingController inputController;

  final FocusNode focusNode;
  final String? labelText;
  final String? errorText;
  final TextStyle? errorStyle;
  final EdgeInsetsGeometry? contentPadding;
  final int inputStyle;

  NormalInputText(
      {Key? key,
      this.type,
      this.hintText,
      this.labelText,
      this.errorText,
      this.errorStyle,
      this.contentPadding,
      this.textAlign = TextAlign.center,
      this.inputStyle = INPUT_STYLE_ONLY_RIGHT,
      TextEditingController? controller,
      FocusNode? focusNode})
      : inputController = controller ?? TextEditingController(),
        focusNode = focusNode ?? FocusNode(),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _InputTextState();
}

class _InputTextState extends State<NormalInputText> {
  var _hasFocus = false;
  var _text = "";
  var _showPass = false;

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      setState(() {
        _hasFocus = widget.focusNode.hasFocus;
      });
    });

    _text = widget.inputController.text;

    widget.inputController.addListener(() {
      setState(() {
        _text = widget.inputController.text;
      });
    });
  }

  showPassBtClick() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  clearBtClick() {
    widget.inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var isPassType = widget.type == NormalInputText.TYPE_PASS;
    var showPassEye = isPassType && _hasFocus;
    var showClearBt = _hasFocus && _text.isNotEmpty;
    return TextField(
      textAlign: widget.textAlign,
      maxLines: 1,
      keyboardType: isPassType ? TextInputType.visiblePassword : TextInputType.text,
      focusNode: widget.focusNode,
      controller: widget.inputController,
      obscureText: isPassType ? !_showPass : false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontSize: 16),
        floatingLabelStyle: const TextStyle(fontSize: 20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        errorText: widget.errorText,
        errorStyle: widget.errorStyle,
        fillColor: const Color(0xffF2F3F7),
        filled: true,
        //密码框，显示密码按钮
        prefixIcon: _preWidget(showPassEye),
        //清除按钮
        suffixIcon: _sufWidget(showPassEye, showClearBt),
        hintText: _hasFocus ? null : widget.hintText,
        hintStyle: const TextStyle(color: Color(0xffB0B3BF)),
        contentPadding: widget.contentPadding,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.all(Radius.circular(5))),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.solid, color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.solid, color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }

  Widget? _preWidget(bool showPassEye) {
    if (widget.inputStyle == NormalInputText.INPUT_STYLE_LEFTPASS_RIGHTCLEAR) {
      return ButtonWidget(
        child: Container(
          padding: const EdgeInsets.only(left: 20),
          child: Icon(
            showPassEye ? (_showPass ? Icons.visibility_off : Icons.visibility) : null,
            color: const Color(0xffD8D9E0),
          ),
        ),
        onPressed: showPassBtClick,
      );
    }
    return null;
  }

  Widget? _sufWidget(bool showPassEye, bool showClearBt) {
    if (widget.inputStyle == NormalInputText.INPUT_STYLE_LEFTPASS_RIGHTCLEAR) {
      //显示clear
      return ButtonWidget(
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(
            showClearBt ? Icons.clear : null,
            color: const Color(0xffD8D9E0),
          ),
        ),
        onPressed: clearBtClick,
      );
    }

    if (widget.type == NormalInputText.TYPE_PASS) {
      if (showPassEye) {
        return ButtonWidget(
          child: Container(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
              showPassEye ? (_showPass ? Icons.visibility_off : Icons.visibility) : null,
              color: const Color(0xffD8D9E0),
            ),
          ),
          onPressed: showPassBtClick,
        );
      }
      return null;
    } else {
      if (showClearBt) {
        return ButtonWidget(
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              showClearBt ? Icons.clear : null,
              color: const Color(0xffD8D9E0),
            ),
          ),
          onPressed: clearBtClick,
        );
      }
      return null;
    }
  }
}
