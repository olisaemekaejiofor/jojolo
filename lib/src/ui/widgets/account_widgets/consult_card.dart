import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/ui/screens/home_screens/account/consult_history/consult_details.dart';
import 'package:jojolo_mobile/src/utils/page_route.dart';

import '/src/data/models/user/doctor.dart';
import '../../../data/models/user/caregiver.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';

class ConsultCard extends StatelessWidget {
  final ConsultationHistory? history;
  final ConsultHistory? chistory;
  const ConsultCard({Key? key, this.history, this.chistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CustomPageRoute(
          child: ConsultDetails(
            history: history,
            chistory: chistory,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (chistory == null)
                  ? history!.presentingComplaint!
                  : chistory!.presentingComplaint!,
              style: style(FontWeight.w700, 18, tabColor),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (chistory == null) ? '' : 'With ${chistory!.doctorId!.fullName}',
                  style: style(FontWeight.normal, 15, textColorBlack),
                ),
                Text(
                  'Done',
                  style: style(FontWeight.normal, 15, textColorBlack),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
