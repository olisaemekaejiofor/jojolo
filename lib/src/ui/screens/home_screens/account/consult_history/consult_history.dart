import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../widgets/account_widgets/consult_card.dart';
import '/src/controllers/home_controllers/account_controller.dart';
import '/src/di/service_locator.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/utils/colors.dart';

class ConsultHistory extends StatefulWidget {
  static const routeName = 'consult-history';
  const ConsultHistory({Key? key}) : super(key: key);

  @override
  State<ConsultHistory> createState() => _ConsultHistoryState();
}

class _ConsultHistoryState extends State<ConsultHistory> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    controller.getUser();
    controller.getType();
    super.initState();
  }

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
          return SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 60),
                lauthControl('Consultation History'),
                const SizedBox(height: 25),
                (controller.loading == false)
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: (controller.userType == 'caregiver')
                                ? List.generate(
                                    controller.userCaregiver.consultationHistory.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10),
                                      child: ConsultCard(
                                        chistory: controller
                                            .userCaregiver.consultationHistory[index],
                                      ),
                                    ),
                                  )
                                : List.generate(
                                    controller.userDoctor.consultationHistory.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10),
                                      child: ConsultCard(
                                        history: controller
                                            .userDoctor.consultationHistory[index],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(tabColor),
                          ),
                        ),
                      ),
                const SizedBox(height: 15),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                //   child: ConsultCard(),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// class ConsultDetails extends StatelessWidget {
//   static const routeName = 'consult-details';
//   const ConsultDetails({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [],
//         ),
//       ),
//     );
//   }
// }
