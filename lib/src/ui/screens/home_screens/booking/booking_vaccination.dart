// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/app_flush.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/bottom_sheet.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/text_fields.dart';
import 'package:jojolo_mobile/src/utils/text_style.dart';
import '../../../widgets/app_widgets/buttons.dart';
import '../../../widgets/app_widgets/page_item.dart';
import '../../../widgets/app_widgets/stepper_widget.dart';
import '/src/controllers/home_controllers/booking_controller.dart';
import '/src/di/service_locator.dart';
import '/src/utils/colors.dart';
import 'package:provider/provider.dart';

class VaccinationService extends StatefulWidget {
  static const routeName = 'vaccination-service';
  const VaccinationService({Key? key}) : super(key: key);

  @override
  State<VaccinationService> createState() => _VaccinationServiceState();
}

class _VaccinationServiceState extends State<VaccinationService> {
  final BookingController controller = serviceLocator<BookingController>();

  @override
  void initState() {
    controller.getChild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(controller),
    );
  }

  _buildBody(BookingController controller) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<BookingController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              const SizedBox(height: 60),
              lauthControl('Book a Vaccination Service'),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: StepProgressView(
                  nature: controller.state,
                  curStep: controller.curStep,
                  titles: const [
                    'Child\nInformation',
                    'Current\nHealth Status',
                    'Select\nVaccine',
                  ],
                  width: double.infinity,
                  color: textButtonColor,
                  vaccine: true,
                  lineActive: const Color(0xff6ED698),
                ),
              ),
              Expanded(
                  child: (controller.loading == false)
                      ? PageView.builder(
                          controller: controller.controller,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            List<Widget> pages = [
                              // first(stuffs),
                              // second(),
                              First(
                                children: List.generate(controller.child.length,
                                    (index) => controller.child[index].childName!),
                                controller1: controller.where,
                                controller2: controller.address,
                                controller3: controller.city,
                                onChange: (value) {
                                  controller.nameofChild.text = value;
                                },
                              ),
                              Second(
                                controller1: controller.allergies,
                                controller2: controller.specialneeds,
                                controller3: controller.text,
                                onTap: () {},
                                list: {
                                  'allergies': [],
                                  'medications': [],
                                  'special_needs': [],
                                },
                              ),
                              Third(name: controller.nameofChild.text),
                            ];
                            return SingleChildScrollView(
                              child: PageItem(
                                index,
                                child: pages[index],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(tabColor),
                          ),
                        )),
              (controller.buttonLoad == true)
                  ? const LoadingCustomButton()
                  : (controller.curStep == 1)
                      ? CustomButton(
                          label: 'Next',
                          onTap: () {
                            if (controller.nameofChild.text.isEmpty ||
                                controller.where.text.isEmpty ||
                                controller.address.text.isEmpty ||
                                controller.city.text.isEmpty) {
                              showFlush(context,
                                  message: 'All Fields are neccessary',
                                  image: 'assets/Active.svg',
                                  color: errorColor);
                            } else {
                              setState(
                                () {
                                  controller.controller.nextPage(
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeIn);
                                  controller.curStep++;
                                  controller.state = Nature.one;
                                },
                              );
                            }
                          },
                        )
                      : (controller.curStep == 2)
                          ? CustomDoubleButton(
                              label: 'Next',
                              label2: 'Back to Child Information',
                              onTap: () {
                                setState(
                                  () {
                                    controller.controller.nextPage(
                                        duration: const Duration(milliseconds: 250),
                                        curve: Curves.easeIn);
                                    controller.curStep++;
                                    controller.state = Nature.two;
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
                              label: 'Book Vaccination',
                              label2: 'Back to Current Health Status',
                              onTap: () => controller.bookVaccine(context),
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
}

// ignore: must_be_immutable
class First extends StatefulWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final void Function(String) onChange;
  final List<String> children;
  const First(
      {Key? key,
      required this.controller1,
      required this.onChange,
      required this.children,
      required this.controller2,
      required this.controller3})
      : super(key: key);

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Who are you trying to Immunize?',
            style: style(FontWeight.w600, 16, textColorBlack),
          ),
          Column(
            children: List.generate(
              widget.children.length,
              (index) =>
                  customRadioButton(widget.children[index], index + 1, onPressed: () {
                setState(() {
                  value = index + 1;
                });
                widget.onChange(widget.children[index]);
              }),
            ),
          ),
          const SizedBox(height: 20),
          TextFieldBottomSheet(
            label: 'Where would the vaccine be administered at?',
            list: const ['Home', 'School or Creche', 'Workplace'],
            controller: widget.controller1,
            onChanged: widget.onChange,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Address',
            controller: widget.controller2,
            error: '',
          ),
          const SizedBox(height: 10),
          TextFieldBottomSheet(
            label: 'City',
            list: const ['Lagos', 'Lagos Island', 'Mainland'],
            controller: widget.controller3,
            onChanged: widget.onChange,
          )
        ],
      ),
    );
  }

  Widget customRadioButton(String text, int index, {void Function()? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 5),
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
}

class Second extends StatefulWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final VoidCallback onTap;
  final Map<String, List<String>> list;
  const Second({
    Key? key,
    required this.controller1,
    required this.onTap,
    required this.list,
    required this.controller2,
    required this.controller3,
  }) : super(key: key);

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          ChipsTextFeild(
              controller: widget.controller1,
              onTap: () {
                widget.list['allergies']!.add(widget.controller1.text);
                widget.controller1.clear();

                setState(() {
                  widget.list['allergies'] = widget.list['allergies']!;
                });
              },
              label: 'Allergies'),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: buildChips(widget.list['allergies']!),
          ),
          ChipsTextFeild(
              controller: widget.controller2,
              onTap: () {
                widget.list['special_needs']!.add(widget.controller2.text);
                widget.controller2.clear();

                setState(() {
                  widget.list['special_needs'] = widget.list['special_needs']!;
                });
              },
              label: 'Special Needs (i.e Mental or Physical Needs)'),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: buildChips(widget.list['special_needs']!),
          ),
          // ChipsTextFeild(
          //   controller: widget.controller3,
          //   onTap: () {
          //     widget.list['medications']!.add(widget.controller3.text);
          //     widget.controller3.clear();

          //     setState(() {
          //       widget.list['medications'] = widget.list['medications']!;
          //     });
          //   },
          //   label: 'Special Needs (i.e Mental or Physical Needs)',
          // ),
          // const SizedBox(height: 10),
          // SizedBox(
          //   height: 30,
          //   child: buildChips(widget.list['medications']!),
          // ),
        ],
      ),
    );
  }

  Widget buildChips(List<String> _values) {
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
            // onPressed: () {
            //   setState(() {
            //     _selected[i] = !_selected[i];
            //   });
            // },
            onDeleted: () {
              _values.removeAt(i);

              setState(() {
                _values = _values;
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
}

class Third extends StatefulWidget {
  final String name;
  const Third({Key? key, required this.name}) : super(key: key);

  @override
  State<Third> createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Text('Upcoming Vaccines for ${widget.name}(2)',
              style: style(FontWeight.bold, 16, textColorBlack)),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset('assets/child-img.png', width: 20, height: 20),
              const SizedBox(width: 10),
              Text(widget.name, style: style(FontWeight.w500, 14, textColorBlack)),
            ],
          ),
          const SizedBox(height: 20),
          customRadioButton('Typherix', '(Against typhoid)', 'Dosage 1 of 1',
              'To be administered at 24months', 1,
              onPressed: () => setState(() {
                    value = 1;
                  })),
          const SizedBox(height: 10),
          customRadioButton(
              'Pentavelent Booster',
              '(Against Hepatitis B, Haemophilius\nInfluenza Type B (HiB), Diphteria,\nPertussis, Tetanus)',
              'Dosage 1 of 3',
              'To be administered at 24months',
              2,
              onPressed: () => setState(() {
                    value = 2;
                  }))
        ],
      ),
    );
  }

  Widget customRadioButton(
      String text, String text1, String text2, String text3, int index,
      {void Function()? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: style(FontWeight.bold, 15, textColorBlack)),
              const SizedBox(height: 10),
              Text(text1, style: style(FontWeight.w600, 14, textColorBlack)),
              const SizedBox(height: 10),
              Text(text2, style: style(FontWeight.w600, 14, tabColor)),
              const SizedBox(height: 10),
              Text(text3, style: style(FontWeight.w600, 14, textButtonColor)),
            ],
          ),
        ],
      ),
    );
  }
}
