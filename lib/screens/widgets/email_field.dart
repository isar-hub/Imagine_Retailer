
import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final bool fadeEmail;
  final TextEditingController emailController;
  const EmailField(
      {super.key, required this.emailController, required this.fadeEmail});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField>
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
    final tween = ColorTween(begin: Colors.grey.withOpacity(0), end: Colors.blue);

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
          tween: Tween(begin: 0, end: widget.fadeEmail ? 0 : 1),
          builder: ((_, value, __) => Opacity(
            opacity: value,
            child: TextFormField(
              controller: emailController,
              focusNode: node,
              cursorColor: Colors.white,
              decoration:

              InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(borderSide: BorderSide.none),

              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  if (isValidEmail(value)) {
                    setState(() {
                      bottomAnimationValue = 0;
                      opacityAnimationValue = 1;
                      paddingAnimationValue = EdgeInsets.only(top: 0);
                    });
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                    setState(() {
                      bottomAnimationValue = 1;
                      opacityAnimationValue = 0;
                      paddingAnimationValue = EdgeInsets.only(top: 22);
                    });
                  }
                } else {
                  setState(() {
                    bottomAnimationValue = 0;
                  });
                }
              },
            ),
          )),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: widget.fadeEmail ? 0 : 300,
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
              tween: Tween(begin: 0, end: widget.fadeEmail ? 0 : 1),
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

  bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final bool fadePassword;

  final IconData? iconData;
  final String? hintText;
  const PasswordField(
      {super.key,
        required this.passwordController,
        required this.fadePassword, this.iconData, this.hintText});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  double bottomAnimationValue = 0;
  double opacityAnimationValue = 0;
  late TextEditingController passwordController;
  bool obscure = true;
  FocusNode node = FocusNode();
  @override
  void initState() {
    passwordController = widget.passwordController;
    node.addListener(() {
      if (!node.hasFocus) {
        setState(() {
          bottomAnimationValue = 0;
          opacityAnimationValue = 0;
        });
      } else {
        setState(() {
          bottomAnimationValue = 1;
          opacityAnimationValue = 1;
        });
        if (passwordController.text.isEmpty) {
          setState(() {
            bottomAnimationValue = 1;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300),
          tween: Tween(begin: 0, end: widget.fadePassword ? 0 : 1),
          builder: ((_, value, __) => Opacity(
            opacity: value,
            child: TextFormField(
              controller: passwordController,
              focusNode: node,
              cursorColor: Colors.black,
              decoration:

              InputDecoration(

                hintText: widget.hintText ??"Password",
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: Icon(widget.iconData,color: Colors.black,),


              ),
              obscureText: obscure,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    bottomAnimationValue = 0;
                    opacityAnimationValue = 0;
                  });
                } else {
                  if (bottomAnimationValue == 0) {
                    setState(() {
                      bottomAnimationValue = 1;
                      opacityAnimationValue = 1;
                    });
                  }
                }
              },
            ),
          )),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: widget.fadePassword ? 0 : 300,
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
          child: TweenAnimationBuilder<double>(
            tween: Tween(
                begin: 0,
                end: opacityAnimationValue == 0
                    ? 0
                    : widget.fadePassword
                    ? 0
                    : 1),
            duration: Duration(milliseconds: 700),
            builder: ((context, value, child) => Opacity(
              opacity: value,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0)
                      .copyWith(bottom: 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    child: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      size: 27,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )),
          ),
        )
      ],
    );
  }
}