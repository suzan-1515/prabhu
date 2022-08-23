import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:prabhu_movie_recommendation_system/utils/view_utils.dart';

import '../../service/auths_service.dart';
import '../../service/common.dart';
import '../../style/style.dart';
import 'login.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String? newPassword, confirmPassword;
  bool newPasswordVisible = true, confirmPasswordVisible = true;

  bool isChangePasswordLoading = false;

  changePassword() async {
    final form = _formKey.currentState;
    if (form?.validate() ?? false) {
      form?.save();

      if (newPassword != confirmPassword) {
        return ViewUtils.showSnackBar(
            'Confirmation Password do not match.', _scaffoldKey);
      }

      if (mounted) {
        setState(() {
          isChangePasswordLoading = true;
        });
      }
      Map<String, dynamic> body = {
        "password": newPassword,
      };
      await AuthService.changePassword(body).then((onValue) async {
        if (onValue.statusCode == 200) {
          await Common.removeToken();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const LogInPage(),
              ),
              (Route<dynamic> route) => false);
        }
        if (mounted) {
          setState(() {
            isChangePasswordLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isChangePasswordLoading = false;
          });
        }
        ViewUtils.showSnackBar('Error changing password.', _scaffoldKey);
      });
    } else {
      if (mounted) {
        setState(() {
          isChangePasswordLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildLoginPageForm(),
          ],
        ),
      ),
    );
  }

  Widget buildLoginPageForm() {
    return Form(
      key: _formKey,
      child: Theme(
        data: ThemeData(
          brightness: Brightness.dark,
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),
                  buildWelcomeTextLogo(),
                  buildText(),
                  const SizedBox(height: 20),
                  buildWelcomeText(),
                  const SizedBox(height: 10),
                  buildPasswordTextField(),
                  buildConfirmPasswordTextField(),
                  const SizedBox(height: 10),
                  buildResetButton(),
                ],
              ),
            ),
            Positioned(
                top: 40,
                left: 10,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_left,
                      size: 40,
                      color: Colors.black,
                    ))),
          ],
        ),
      ),
    );
  }

  Widget buildText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          "Change Your Password",
          style: textpoppinsMediumBlack(),
        ),
      ),
    );
  }

  Widget buildWelcomeText() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.88,
            child: Text(
              "Enter your new password to change and login with your new password.",
              style: textpoppinsRegularmd(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWelcomeTextLogo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.40,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Image(image: AssetImage('lib/assets/icons/logo.png')),
        ),
      ),
    );
  }

  Widget buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 1,
                  offset: Offset(0.0, 1.0))
            ]),
        child: TextFormField(
          style: textpoppinsRegularBlack(),
          keyboardType: TextInputType.text,
          onSaved: (String? value) {
            newPassword = value;
          },
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "Enter new Password";
              //  MyLocalizations.of(context).enterPassword;
            } else if ((value?.length ?? 0) < 5) {
              return "Please Enter Min 6 Digit Password.";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            hintText: "New Password",
            hintStyle: textpoppinsRegular(),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: const TextStyle(color: Color(0xFFF44242)),
            contentPadding: const EdgeInsets.all(10),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildConfirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45,
                  blurRadius: 1,
                  offset: Offset(0.0, 1.0))
            ]),
        child: TextFormField(
          style: textpoppinsRegularBlack(),
          keyboardType: TextInputType.text,
          onSaved: (String? value) {
            confirmPassword = value;
          },
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "Enter Password";
              //  MyLocalizations.of(context).enterPassword;
            } else if ((value?.length ?? 0) < 5) {
              return "Please Enter Min 6 Digit Password";
              // MyLocalizations.of(context).pleaseEnterMin6DigitPassword;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            hintText: "Confirm Password",
            hintStyle: textpoppinsRegular(),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: const TextStyle(color: Color(0xFFF44242)),
            contentPadding: const EdgeInsets.all(10),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResetButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: MaterialButton(
        onPressed: changePassword,
        textColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
                primary,
                secondary,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Change Password", style: textpoppinsMediumwhite()),
                const SizedBox(
                  height: 10,
                ),
                isChangePasswordLoading
                    ? const GFLoader(
                        type: GFLoaderType.ios,
                      )
                    : const Text("")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
