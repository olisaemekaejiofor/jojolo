import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jojolo_mobile/src/controllers/home_controllers/account_controller.dart';
import 'package:jojolo_mobile/src/ui/widgets/app_widgets/auth_controls.dart';
import 'package:provider/provider.dart';
import '../../../../di/service_locator.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text_style.dart';
import '../../../widgets/app_widgets/text_fields.dart';

class PayPerUseScreen extends StatefulWidget {
  final String? doctorName;
  final String? type;
  final String? amount;
  static const routeName = 'pay_per_use';

  const PayPerUseScreen({Key? key, this.doctorName, this.type, this.amount})
      : super(key: key);

  @override
  State<PayPerUseScreen> createState() => _PayPerUseScreenState();
}

class _PayPerUseScreenState extends State<PayPerUseScreen> {
  final AccountController controller = serviceLocator<AccountController>();

  @override
  void initState() {
    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController serviceController = TextEditingController();

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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              lauthControl('Payment Details'),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: nameController,
                      label: 'Doctor Name',
                      error: 'Please enter your subscription cost',
                      type: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    Text(
                      'Booking Amount',
                      style: style(FontWeight.w600, 16, textColorBlack),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: amountController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: errorColor, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 0,
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: textfieldFillColor, width: 1),
                          ),
                          fillColor: textfieldFillColor,
                          filled: true,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.nairaSign,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: nameController,
                      label: 'Booking Service',
                      error: 'Please enter your choice of service',
                      type: TextInputType.name,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
