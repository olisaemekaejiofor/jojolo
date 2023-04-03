import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/src/controllers/home_controllers/account_controller.dart';
import '/src/di/service_locator.dart';
import '/src/ui/widgets/app_widgets/auth_controls.dart';
import '/src/ui/widgets/app_widgets/buttons.dart';
import '/src/ui/widgets/app_widgets/tab.dart';
import '/src/utils/colors.dart';
import '../../../../widgets/account_widgets/plan_cards.dart';
import '../../../../widgets/app_widgets/page_item.dart';

class ManageSubscription extends StatefulWidget {
  static const routeName = 'manage-subs';
  const ManageSubscription({Key? key}) : super(key: key);

  @override
  State<ManageSubscription> createState() => _ManageSubscriptionState();
}

class _ManageSubscriptionState extends State<ManageSubscription> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    Provider.of<AccountController>(context, listen: false)
        .plugin
        .initialize(publicKey: controller.publicKey);
    // controller.getSubPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Consumer<AccountController>(
      builder: (context, controller, _) {
        List<Widget> widget = [
          PlanCards(
            color: textButtonColor,
            background: textButtonColorOpa,
            text: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Basic')
                    .subscriptionName ??
                'Baisic',
            amount: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Basic')
                    .monthlyPlan[0]
                    .planAmount
                    .toString() ??
                '',
            amountYear: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Basic')
                    .yearlyPlan[0]
                    .planAmount
                    .toString() ??
                '',
            monthly: const ['Child Health Tracker', 'Chat with a Doctor'],
            yearly: const [
              'Child Health Tracker',
              'Chat with a Doctor',
              'Wellness Check'
            ],
          ),
          PlanCards(
            color: tabColor,
            background: tab2Background,
            text: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Standard')
                    .subscriptionName ??
                'Standard',
            amount: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Standard')
                    .monthlyPlan[0]
                    .planAmount
                    .toString() ??
                '',
            amountYear: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Standard')
                    .yearlyPlan[0]
                    .planAmount
                    .toString() ??
                '',
            monthly: const [
              'Child Health Tracker',
              'Chat with a Doctor',
              'Virtual Consultation with\n a Doctor'
            ],
            yearly: const [
              'Child Health Tracker',
              'Chat with a Doctor',
              'Wellness Check',
              'Virtual Consultation'
            ],
          ),
          PlanCards(
            color: tab3Color,
            background: tab3Background,
            text: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Premium')
                    .subscriptionName ??
                'Premium',
            amount: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Premium')
                    .monthlyPlan[0]
                    .planAmount
                    .toString() ??
                '',
            amountYear: controller.plans
                    ?.firstWhere((e) => e.subscriptionName == 'Premium')
                    .yearlyPlan[0]
                    .planAmount
                    .toString() ??
                '',
            monthly: const [
              'Child Health Tracker',
              'Chat with a Doctor',
              'Virtual Consultation with\n a Doctor'
            ],
            yearly: const [
              'Child Health Tracker',
              'Chat with a Doctor',
              'Wellness Check',
              'Virtual Consultation'
            ],
          ),
        ];
        return Column(
          children: [
            const SizedBox(height: 60),
            lauthControl('Manage Subscriptions'),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SubTab(
                  pageController: controller.controller,
                  tabController: controller.tabBarController,
                  list: controller.list),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.controller,
                itemCount: controller.list.length,
                itemBuilder: (context, index) {
                  return PageItem(
                    index,
                    child: widget[index],
                  );
                },
              ),
            ),
            (controller.buttonLoad == true)
                ? const LoadingCustomButton()
                : CustomButton(
                    label: 'Subscribe',
                    onTap: () => controller.subscribe(
                        context, controller.controller.page!.toInt()),
                  )
          ],
        );
      },
    );
  }
}
