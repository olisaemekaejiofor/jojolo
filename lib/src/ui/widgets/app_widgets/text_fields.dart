import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/src/utils/colors.dart';
import '../../../utils/text_style.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String error;
  final TextInputType? type;
  final bool? isEmail;
  final bool? isPhone;
  final bool? readOnly;
  final double? height;
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.type,
      this.isEmail,
      required this.label,
      required this.error,
      this.isPhone,
      this.height,
      this.readOnly})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: style(FontWeight.w600, 16, textColorBlack),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: widget.height ?? 45,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.type,
            maxLines: (widget.height == null) ? 1 : 7,
            readOnly: widget.readOnly ?? false,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: validate == true
                    ? const BorderSide(color: errorColor, width: 1)
                    : BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: widget.controller.text.isEmpty
                    ? BorderSide.none
                    : const BorderSide(color: greenColor, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: errorColor),
              ),
              // errorText: validate ? widget.error : null,
              fillColor: textfieldFillColor,
              filled: true,
            ),
            onChanged: (value) {
              if (widget.isEmail == true) {
                if (RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%^&*+-/=?_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]")
                    .hasMatch(value)) {
                  setState(() {
                    validate = false;
                  });
                } else {
                  setState(() {
                    validate = true;
                  });
                }
              } else if (widget.isPhone == true) {
                if (value.length == 11) {
                  setState(() {
                    validate = false;
                  });
                } else {
                  setState(() {
                    validate = true;
                  });
                }
              } else {
                if (value.length > 3) {
                  setState(() {
                    validate = false;
                  });
                } else {
                  setState(() {
                    validate = true;
                  });
                }
              }
            },
          ),
        ),
        Visibility(
          visible: validate,
          child: Text(
            widget.error,
            style: style(FontWeight.w600, 14, errorColor),
          ),
        ),
      ],
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? error;
  final String? compare;
  final TextInputType? type;
  const PasswordTextField(
      {Key? key,
      required this.controller,
      required this.label,
      this.error,
      this.type,
      this.compare})
      : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool validate = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: style(FontWeight.w600, 16, textColorBlack),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.type,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: widget.controller.text.isNotEmpty
                    ? BorderSide.none
                    : const BorderSide(color: errorColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: widget.controller.text.isEmpty
                    ? BorderSide.none
                    : const BorderSide(color: greenColor, width: 1),
              ),
              fillColor: textfieldFillColor,
              filled: true,
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                icon: (obscure == false)
                    ? const FaIcon(
                        FontAwesomeIcons.eye,
                        color: iconColor,
                        size: 15,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.eyeSlash,
                        color: iconColor,
                        size: 15,
                      ),
              ),
            ),
            obscureText: obscure,
            onChanged: (value) {
              if (widget.error != null || widget.error != '') {
                if (widget.controller.text == widget.compare) {
                  setState(() {
                    validate = false;
                  });
                } else {
                  validate = true;
                }
              }
            },
          ),
        ),
        // Visibility(
        //   visible: validate,
        //   child: Text(
        //     widget.error!,
        //     style: style(FontWeight.w600, 14, errorColor),
        //   ),
        // ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle styleActive = style(FontWeight.w500, 16, textColorBlack);
    TextStyle styleHint = style(FontWeight.w500, 16, bottomNavIcon);
    final tstyle = controller.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: searchFillColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: (controller.text.isEmpty)
              ? SvgPicture.asset(
                  'assets/search.svg',
                  width: 20,
                  color: bottomNavIcon,
                )
              : const SizedBox(),
          suffixIcon: (controller.text.isNotEmpty)
              ? GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: actionButton,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.close,
                      color: fixedBottomColor,
                      size: 15,
                    )),
                  ),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : const SizedBox(),
          hintText: widget.hintText,
          hintStyle: tstyle,
          // contentPadding: const EdgeInsets.only(bottom: 8),
          border: InputBorder.none,
        ),
        style: tstyle,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class CommentField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String error;
  final TextInputType? type;
  final bool? isEmail;
  final bool? isPhone;
  final double? height;
  const CommentField(
      {Key? key,
      required this.controller,
      required this.label,
      required this.error,
      this.type,
      this.isEmail,
      this.isPhone,
      this.height})
      : super(key: key);

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  bool validate = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.type,
      maxLines: (widget.height == null) ? 1 : 7,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: validate == true
              ? const BorderSide(color: errorColor, width: 1)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(10),
          borderSide: widget.controller.text.isEmpty
              ? BorderSide.none
              : const BorderSide(color: greenColor, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor),
        ),
        // errorText: validate ? widget.error : null,
        fillColor: textfieldFillColor,
        hintText: 'Add a comment',
        filled: true,
      ),
      onChanged: (value) {
        if (widget.isEmail == true) {
          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%^&*+-/=?_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]")
              .hasMatch(value)) {
            setState(() {
              validate = false;
            });
          } else {
            setState(() {
              validate = true;
            });
          }
        } else if (widget.isPhone == true) {
          if (value.length == 11) {
            setState(() {
              validate = false;
            });
          } else {
            setState(() {
              validate = true;
            });
          }
        } else {
          if (value.length > 3) {
            setState(() {
              validate = false;
            });
          } else {
            setState(() {
              validate = true;
            });
          }
        }
      },
    );
  }
}

class DateFeild extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;
  const DateFeild(
      {Key? key, required this.controller, required this.onTap, required this.label})
      : super(key: key);

  @override
  State<DateFeild> createState() => _DateFeildState();
}

class _DateFeildState extends State<DateFeild> {
  bool validate = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: style(FontWeight.w600, 16, textColorBlack),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 45,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AbsorbPointer(
              child: TextFormField(
                controller: widget.controller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: validate == true
                        ? const BorderSide(color: errorColor, width: 1)
                        : BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(10),
                    borderSide: widget.controller.text.isEmpty
                        ? BorderSide.none
                        : const BorderSide(color: greenColor, width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: errorColor),
                  ),
                  // icon: const Icon(Icons.calendar_today),
                  fillColor: textfieldFillColor,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a date for your task";
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChipsTextFeild extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final String label;
  const ChipsTextFeild(
      {Key? key, required this.controller, required this.onTap, required this.label})
      : super(key: key);

  @override
  State<ChipsTextFeild> createState() => _ChipsTextFeildState();
}

class _ChipsTextFeildState extends State<ChipsTextFeild> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.label,
        style: style(FontWeight.w600, 16, textColorBlack),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 45,
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(10),
              borderSide: widget.controller.text.isEmpty
                  ? BorderSide.none
                  : const BorderSide(color: greenColor, width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor),
            ),
            // errorText: validate ? widget.error : null,
            fillColor: textfieldFillColor,
            filled: true,
            hintText: 'Type here and click on the add Icon',
            hintStyle: style(FontWeight.w600, 15, textColorGrey),
            suffixIcon: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: tabColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 15),
              ),
            ),
          ),
          onChanged: (value) {},
        ),
      ),
    ]);
  }
}

class NormalTextFeild extends StatefulWidget {
  final TextEditingController controller;
  const NormalTextFeild({Key? key, required this.controller}) : super(key: key);

  @override
  State<NormalTextFeild> createState() => _NormalTextFeildState();
}

class _NormalTextFeildState extends State<NormalTextFeild> {
  bool validate = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: validate == true
              ? const BorderSide(color: errorColor, width: 1)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(10),
          borderSide: widget.controller.text.isEmpty
              ? BorderSide.none
              : const BorderSide(color: textfieldFillColor, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor),
        ),
        // icon: const Icon(Icons.calendar_today),
        fillColor: textfieldFillColor,
        filled: true,
        hintText: 'Type your message here',
        hintStyle: style(FontWeight.w600, 16, textColorGrey),
        contentPadding: const EdgeInsets.only(top: 5, left: 10),
      ),
      style: style(FontWeight.w600, 17, textColorBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter a date for your task";
        }
        return null;
      },
    );
  }
}
