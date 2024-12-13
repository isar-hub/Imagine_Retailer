import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController emailController;

  final String label;
  final IconData iconData;
  int maxLines = 1;
  Function(String?)? validator;
  final TextInputType inputType;
  CommonTextField({super.key, required this.emailController,  required this.label, required this.iconData, this.validator,this.maxLines =1,  this.inputType = TextInputType.text});

  @override
  State<CommonTextField> createState() => _CommonFieldState();
}

class _CommonFieldState extends State<CommonTextField>
    with SingleTickerProviderStateMixin {
  double bottomAnimationValue = 0;
  double opacityAnimationValue = 0;
  EdgeInsets paddingAnimationValue = EdgeInsets.only(top: 22);
  late TextEditingController emailController;
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  FocusNode node = FocusNode();
  @override
  void initState() {
    emailController = widget.emailController;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    final tween =
        ColorTween(begin: Colors.grey.withOpacity(0), end: Colors.blue);

    _animation = tween.animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();

    node.addListener(() {
      if (node.hasFocus) {
        setState(() {
          bottomAnimationValue = 1;
        });
      } else {
        setState(() {
          bottomAnimationValue = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300),
          tween: Tween(begin: 0, end: 1),
          builder: ((_, value, __) => Opacity(
                opacity: value,
                child: TextFormField(
                  controller: emailController,
                  focusNode: node,

                  cursorColor: Colors.black,
                  maxLines: widget.maxLines,
                  decoration: InputDecoration(
                    label: Text(widget.label),
                    prefixIcon: Icon(widget.iconData,color: Colors.black,),
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  keyboardType: widget.inputType,
                  validator:(value)=> widget.validator!(value),
                ),
              )),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 300,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: bottomAnimationValue),
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
                builder: ((context, value, child) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white,
                      color: Colors.black,
                    )),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedPadding(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 500),
            padding: paddingAnimationValue,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 700),
              builder: ((context, value, child) => Opacity(
                    opacity: value,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0)
                            .copyWith(bottom: 0),
                        child: Icon(Icons.check_rounded,
                            size: 27,
                            color: _animation.value // _animation.value,
                            ),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
