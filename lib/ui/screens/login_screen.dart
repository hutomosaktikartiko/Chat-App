import 'package:chat_app/ui/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

import '../../config/custom_color.dart';
import '../../config/custom_label.dart';
import '../../services/auth_services.dart';
import '../../utils/size_config.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_numerical_keyboard.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();

  void _onKeyboardTap(String value) {
    setState(() {
      phoneNumberController.text = phoneNumberController.text + value;
    });
  }

  void _onKeyboardBackspaceTap() {
    if (phoneNumberController.text.length > 0) {
      setState(() {
        phoneNumberController.text = phoneNumberController.text
            .substring(0, phoneNumberController.text.length - 1);
      });
    }
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: buildBody(),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultMargin),
          child: Text(
            CustomLabel.loginLabel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultMargin),
          child: Text(
            CustomLabel.loginDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        SizedBox(
          height: 42,
        ),
        Container(
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultMargin),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Image.asset("assets/images/flag_id.png"),
                    SizedBox(
                      width: 8,
                    ),
                    Text("+62",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: (Theme.of(context).scaffoldBackgroundColor ==
                                    NeutralColor.white)
                                ? NeutralColor.disabled
                                : NeutralColor.offWhite))
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: CustomTextField(
                controller: phoneNumberController,
                hintText: "Phone Number",
                readOnly: true,
              ))
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultMargin),
          child: CustomButton(
              label: "Continue",
              onTap: () async {
                if (phoneNumberController.text.trim().length > 0) {
                  await AuthServices.verifyPhoneNumber(
                    context: context,
                    phoneNumber: "+62" + phoneNumberController.text,
                  );
                } else {
                  CustomDialog.showToast(message: "Masukan nomor dengan benar!");
                }
              }),
        ),
        SizedBox(
          height: 32,
        ),
        CustomNumericalKeyboard(
          onKeyboardTap: _onKeyboardTap,
          rightButtonFn: _onKeyboardBackspaceTap,
        )
      ],
    );
  }
}
