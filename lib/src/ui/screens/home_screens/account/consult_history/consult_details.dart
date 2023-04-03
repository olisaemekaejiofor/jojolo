import 'package:flutter/material.dart';
import '/src/data/models/user/caregiver.dart';
import '/src/data/models/user/doctor.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/utils/colors.dart';
import '/src/utils/text_style.dart';

class ConsultDetails extends StatelessWidget {
  static const routeName = 'consult-details';
  final ConsultationHistory? history;
  final ConsultHistory? chistory;
  const ConsultDetails({Key? key, this.history, this.chistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: (history == null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                lauthControl(chistory!.presentingComplaint!),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Consultation with ' + chistory!.doctorId!.fullName!,
                            style: style(FontWeight.w500, 18, textColorBlack),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Name of Child',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chistory!.childInformationId.toString(),
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Presenting Complaint',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chistory!.presentingComplaint!,
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Doctors Advice',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chistory!.advise!,
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Working Diagnosis',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chistory!.workingDiagnosis!,
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Observations',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chistory!.observations!,
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                lauthControl(history!.presentingComplaint!),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Consultation with ' + history!.referrals!,
                            style: style(FontWeight.w500, 18, textColorBlack),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Name of Child',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            history!.childInformationId.toString(),
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Presenting Complaint',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            history!.presentingComplaint!,
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Doctors Advice',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            history!.advise!,
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Working Diagnosis',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            history!.workingDiagnosis!,
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Observations',
                            style: style(FontWeight.w600, 16, textColorGrey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            history!.observations.toString(),
                            style: style(FontWeight.w600, 16, textColorBlack),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
