// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/app_flush.dart';
import '/src/controllers/home_controllers/account_controller.dart';
import '/src/di/service_locator.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/ui/widgets/app_widgets/bottom_sheet.dart';
import '/src/ui/widgets/app_widgets/buttons.dart';
import '/src/ui/widgets/app_widgets/page_item.dart';
import '/src/ui/widgets/app_widgets/stepper_widget.dart';
import '/src/ui/widgets/app_widgets/text_fields.dart';
import '/src/utils/text_style.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';

class ChildDetails extends StatefulWidget {
  static const routeName = 'child-details';
  const ChildDetails({Key? key}) : super(key: key);

  @override
  State<ChildDetails> createState() => _ChildDetailsState();
}

class _ChildDetailsState extends State<ChildDetails> {
  final AccountController controller = serviceLocator<AccountController>();
  int sharedValue = 0;
  int value = 0;
  List<String> _values = [];
  List<bool> _selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(AccountController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<AccountController>(
        builder: (context, controller, _) {
          Map<int, Widget> stuffs = <int, Widget>{
            0: tab1(sharedValue),
            1: tab2(sharedValue),
          };

          return Column(
            children: [
              const SizedBox(height: 60),
              dauthControl(context, 'account-settings', 'Skip', 'Add Child'),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: StepProgressView(
                  nature: controller.state,
                  curStep: controller.curStep,
                  titles: const [
                    'Child\nInformation',
                    'Past Medical\nHistory',
                    'Select What\nTo Track',
                  ],
                  width: double.infinity,
                  color: textButtonColor,
                  lineActive: const Color(0xff6ED698),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller.controller,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    List<Widget> pages = [
                      first(stuffs),
                      second(),
                      third(),
                    ];
                    return SingleChildScrollView(
                      child: PageItem(
                        index,
                        child: pages[index],
                      ),
                    );
                  },
                ),
              ),
              (controller.buttonLoad == true)
                  ? const LoadingCustomButton()
                  : (controller.curStep == 1)
                      ? CustomButton(
                          label: 'Next',
                          onTap: () {
                            setState(
                              () {
                                if (controller.fname.text.isNotEmpty ||
                                    controller.dateC.text.isNotEmpty) {
                                  controller.controller.nextPage(
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeIn);
                                  controller.curStep++;
                                  controller.state = Nature.one;
                                } else {
                                  showFlush(
                                    context,
                                    message:
                                        'You can’t continue because there’s an\nempty field in the form.',
                                    image: 'assets/Active.svg',
                                    color: errorColor,
                                  );
                                }
                              },
                            );
                          },
                        )
                      : (controller.curStep == 2)
                          ? CustomDoubleButton(
                              label: 'Next',
                              label2: 'Back to Child Information',
                              onTap: () {
                                setState(
                                  () {
                                    if (controller.bio.text.isNotEmpty ||
                                        controller.lname.text.isNotEmpty) {
                                      controller.controller.nextPage(
                                          duration: const Duration(milliseconds: 250),
                                          curve: Curves.easeIn);
                                      controller.curStep++;
                                      controller.state = Nature.two;
                                    } else {
                                      showFlush(
                                        context,
                                        message:
                                            'You can’t continue because there’s an\nempty field in the form.',
                                        image: 'assets/Active.svg',
                                        color: errorColor,
                                      );
                                    }
                                  },
                                );
                              },
                              onTap2: () {
                                setState(
                                  () {
                                    controller.controller.previousPage(
                                        duration: const Duration(milliseconds: 250),
                                        curve: Curves.easeIn);
                                    controller.curStep--;
                                    controller.state = Nature.zero;
                                  },
                                );
                              },
                            )
                          : CustomDoubleButton(
                              label: 'Add Child & Complete',
                              label2: 'Back to Medical History',
                              onTap: () => controller.addChild(context),
                              onTap2: () {
                                setState(
                                  () {
                                    controller.controller.previousPage(
                                        duration: const Duration(milliseconds: 250),
                                        curve: Curves.easeIn);
                                    controller.curStep--;
                                    controller.state = Nature.one;
                                  },
                                );
                              },
                            ),
            ],
          );
        },
      ),
    );
  }

  Widget first(Map<int, Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'Adding your child is the first step in ensuring you’re aware of how your child is growing and developing.',
            style: style(FontWeight.w600, 16, textColorBlack),
          ),
          const SizedBox(height: 40),
          CustomTextField(
            controller: controller.fname,
            label: "What's Your Child's Name? ",
            error: '',
          ),
          const SizedBox(height: 20),
          DateFeild(
            label: 'Date of Birth',
            controller: controller.dateC,
            onTap: () => controller.selectDate(context),
          ),
          const SizedBox(height: 30),
          Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: textButtonColorOpa,
                primary: Colors.transparent,
              ),
            ),
            child: CupertinoSegmentedControl(
              children: children,
              onValueChanged: (int val) {
                setState(() {
                  sharedValue = val;
                  print(sharedValue);
                });
              },
              groupValue: sharedValue,
              selectedColor: tabColor,
              unselectedColor: Colors.white,
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget second() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'Your child’s medical history information',
            style: style(FontWeight.w600, 16, textColorBlack),
          ),
          const SizedBox(height: 25),
          TextFieldBottomSheet(
            label: 'Blood Group',
            list: const ['A', 'B', 'AB', 'O'],
            controller: controller.bio,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 15),
          TextFieldBottomSheet(
            label: 'Genotype',
            list: const ['AA', 'AS', 'AC', 'SS'],
            controller: controller.lname,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 30),
          Text(
            'Background Health Conditions/Challenges',
            style: style(FontWeight.w500, 16, textColorBlack),
          ),
          const SizedBox(height: 10),
          customRadioButton(
            'Allergies',
            1,
            onPressed: () => setState(() => value = 1),
          ),
          customRadioButton(
            'Special Needs (i.e Mental or Physical Needs)',
            2,
            onPressed: () => setState(() => value = 2),
          ),
          customRadioButton(
            'Medical Conditions (e.g Diabetes, Asthma e.t.c)',
            3,
            onPressed: () => setState(() => value = 3),
          ),
          const SizedBox(height: 20),
          ChipsTextFeild(
            label: 'Allergies',
            controller: controller.email,
            onTap: () {
              _values.add(controller.email.text);
              _selected.add(true);
              controller.email.clear();

              setState(() {
                _values = _values;
                _selected = _selected;
              });
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: buildChips(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget third() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text(
            'Select what you would like to track',
            style: style(FontWeight.w600, 16, textColorBlack),
          ),
          const SizedBox(height: 20),
          customRadio(
            'My Child’s Milestones',
            1,
            onPressed: () => setState(() => value = 1),
          ),
          customRadio(
            'My Child’s Growth',
            2,
            onPressed: () => setState(() => value = 2),
          ),
          customRadio(
            'My Child’s Immunizations',
            3,
            onPressed: () => setState(() => value = 3),
          )
        ],
      ),
    );
  }

  Widget customRadio(String text, int index, {void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            GestureDetector(
              onTap: onPressed,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE8E8E8)),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: (index == value)
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: textButtonColor,
                        ),
                        padding: const EdgeInsets.all(2.0),
                        width: double.infinity,
                        height: double.infinity,
                        child: const Center(
                            child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        )))
                    : Container(),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: style(FontWeight.w600, 16, textColorBlack),
            ),
          ],
        ),
      ),
    );
  }

  Widget customRadioButton(String text, int index, {void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE8E8E8)),
                borderRadius: BorderRadius.circular(40),
              ),
              child: (index == value)
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: textButtonColor,
                      ),
                      padding: const EdgeInsets.all(2.0),
                      width: double.infinity,
                      height: double.infinity,
                      child: const Center(
                          child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      )))
                  : Container(),
            ),
          ),
          const SizedBox(width: 20),
          Text(text, style: style(FontWeight.w600, 14, textColorBlack)),
        ],
      ),
    );
  }

  Widget buildChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _values.length; i++) {
      Widget actionChip = Container(
          margin: const EdgeInsets.only(right: 5),
          child: InputChip(
            // selected: _selected[i],
            label: Text(
              _values[i],
              style: style(FontWeight.w600, 14, tabColor),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: backButtonBackground,
            deleteIcon: const Icon(
              Icons.cancel,
              color: tabColor,
              size: 20,
            ),
            // padding: const EdgeInsets.all(10),
            elevation: 0,
            shadowColor: Colors.transparent,
            onPressed: () {
              setState(() {
                _selected[i] = !_selected[i];
              });
            },
            onDeleted: () {
              _values.removeAt(i);
              _selected.removeAt(i);

              setState(() {
                _values = _values;
                _selected = _selected;
              });
            },
          ));

      chips.add(actionChip);
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  Widget tab1(int check) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(
          "Male",
          style: style(
            FontWeight.w600,
            18,
            (check == 0) ? fixedBottomColor : textColorBlack,
          ),
        ),
      ),
    );
  }

  Widget tab2(int check) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(
          "Female",
          style: style(
            FontWeight.w600,
            18,
            (check == 0) ? textColorBlack : fixedBottomColor,
          ),
        ),
      ),
    );
  }
}
