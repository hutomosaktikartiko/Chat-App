import 'package:chat_app/models/api_return_value.dart';
import 'package:chat_app/ui/screens/fill_profile_data_screen.dart';
import 'package:chat_app/ui/screens/main_screen.dart';
import 'package:chat_app/ui/screens/verification_screen.dart';
import 'package:chat_app/ui/widgets/custom_dialog.dart';
import 'package:chat_app/utils/custom_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

class AuthServices {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<void> verifyPhoneNumber(
      {required String phoneNumber, required BuildContext context}) async {
    ProgressDialog progressDialog = CustomDialog.showProgressDialog(context,
        message: "Sedang memverifikasi nomor");
    progressDialog.show();

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await firebaseAuth.signInWithCredential(phoneAuthCredential);

      print("{ PHONE VERIFY [VERIFICATION COMPLETED] }");

      CustomDialog.showToast(
          message: "Phone number automatically verified and user signed");

      progressDialog.dismiss();

      CustomNavigator().removeAllScreen(context, MainScreen());
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print("{ PHONE VERIFY FAILED [${authException.message}] }");

      String errorMessage = "";
      if (authException.code == 'invalid-phone-number') {
        errorMessage = 'The provided phone number is not valid.';
      } else if (authException.code == "too-many-requests") {
        errorMessage = 'Too many requests on this phone number.';
      } else {
        errorMessage = authException.message ?? "Error";
      }

      progressDialog.dismiss();

      CustomDialog.showToast(message: errorMessage);
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      progressDialog.dismiss();

      print("{ PHONE VERIFY [CODE SEND] }");
      print("{ PHONE VERIFY FORCE RESENDING TOKEN [$forceResendingToken] }");

      CustomNavigator().startScreen(
          context,
          VerificationScreen(
              phoneNumber: phoneNumber, verificationId: verificationId));
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("{ PHONE VERIFY [CODE AUTO RETRIEVAL TIME OUT] }");
      progressDialog.dismiss();
    };

    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  static Future<ApiReturnValue<bool>> signInWithCredential(
      {required List<String?> codeVerification,
      required String verificationId}) async {
    String code = "";
    for (var i in codeVerification) {
      code += i ?? "";
    }

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);

      final User user =
          (await firebaseAuth.signInWithCredential(credential)).user!;

      return ApiReturnValue(isSuccess: true, result: user.uid);
    } catch (e) {
      // TODO: Find how to handle error message code
      // session-expired -> for message if [code verification] is expired
      if (e.toString().contains("session-expired")) {}
      return ApiReturnValue(isSuccess: false, message: e.toString());
    }
  }

  // Logout
  static Future<ApiReturnValue<bool>> signOut() async {
    try {
      await firebaseAuth.signOut();

      print("{ LOGOUT SUCCESS }");

      return ApiReturnValue(value: true);
    } catch (e) {
      print("{ LOGOUT ERROR $e }");
      return ApiReturnValue(
          value: false, message: "Logout failed, please try again");
    }
  }
}
