import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/booking_controller.dart';
import 'package:jojolo_mobile/src/di/service_locator.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/buttons.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';

class PostConsultationForm extends StatefulWidget {
  final String id;
  final String aid;
  final String bid;
  const PostConsultationForm(
      {Key? key, required this.id, required this.aid, required this.bid})
      : super(key: key);

  @override
  State<PostConsultationForm> createState() => _PostConsultationFormState();
}

class _PostConsultationFormState extends State<PostConsultationForm> {
  final BookingController controller = serviceLocator<BookingController>();

  @override
  void initState() {
    setState(() {
      controller.text.text = widget.id;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: ChangeNotifierProvider(
        create: (context) => controller,
        child: Consumer<BookingController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                const SizedBox(height: 60),
                lauthControl('Post Consultation Form'),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: controller.text,
                            label: 'Patient ID',
                            error: '',
                            readOnly: true,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: controller.presentingComplaint,
                            label: 'Presenting Complaint',
                            error: '',
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: controller.observations,
                            label: 'Observations (if applicable)',
                            error: '',
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: controller.workingDiagnosis,
                            label: 'Working Diagnosis',
                            error: '',
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: controller.investigations,
                            label: 'Investigations (if applicable)',
                            error: '',
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: controller.prescription,
                            label: 'Prescription/Advise',
                            error: '',
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                (controller.buttonLoad == true)
                    ? const LoadingCustomButton()
                    : CustomButton(
                        label: 'Save',
                        onTap: () => controller.postConsultation(
                          context,
                          widget.id,
                          widget.aid,
                          widget.bid,
                        ),
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}
