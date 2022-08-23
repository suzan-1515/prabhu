import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:prabhu_movie_recommendation_system/utils/view_utils.dart';

import '../../service/auths_service.dart';
import '../../style/style.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? password1;
  String? password2;
  bool success = false, passwordVisible = true, passwordVisible1 = true;

  bool isLoading = false,
      registrationLoading = false,
      rememberMe = false,
      value = false;
  String? firstName, lastName, email, password;

  @override
  void initState() {
    super.initState();
  }

  userSignup() async {
    final form = _formKey.currentState;
    if (form?.validate() ?? false) {
      form?.save();
      if (mounted) {
        setState(() {
          registrationLoading = true;
        });
      }
      Map<String, dynamic> body = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email?.toLowerCase(),
        "password": password1,
      };

      await AuthService.signUp(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              registrationLoading = false;
            });
          }

          if (onValue.data['statusCode'] == null) {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          'User registration successful.',
                          style: textBarlowRegularBlack(),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "ok",
                        // MyLocalizations.of(context).ok,
                        style: textBarLowRegularaPrimary(),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LogInPage(),
                            ),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            ViewUtils.showSnackBar('${onValue.data['message']}', _scaffoldKey);
          }
        } catch (error) {
          if (mounted) {
            setState(() {
              registrationLoading = false;
            });
          }
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            registrationLoading = false;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          registrationLoading = false;
        });
      }
      return;
    }
  }

  showAlert(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: const Text("error"
              // MyLocalizations.of(context).error,
              // style: textBarlowRegularBlack(),
              // textAlign: TextAlign.center,
              ),
          content: SizedBox(
            height: 100.0,
            child: Column(
              children: <Widget>[
                Text(
                  "$message",
                  style: textBarlowRegularBlack(),
                  textAlign: TextAlign.center,
                ),
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                const Divider(),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const VerticalDivider(),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(),
                            child: const Text(
                              "ok",
                              // MyLocalizations.of(context).ok,
                              // style: textbarlowRegularaPrimary(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
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
                  const SizedBox(height: 15),
                  buildWelcomeTextLogo(),
                  buildWelcomeText(),
                  const SizedBox(height: 20),
                  buildFirstNameTextField(),
                  buildLastNameTextField(),
                  buildEmailTextField(),
                  buildPasswordTextField(),
                  buildConfirmPasswordTextField(),
                  const SizedBox(height: 10),
                  buildSignupButton(),
                  const SizedBox(height: 40),
                  buildLinkButton()
                ],
              ),
            ),
            Positioned(
                top: 50,
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

  Widget buildWelcomeText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          "Sign Up",
          style: textpoppinsMediumBlack(),
        ),
      ),
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

  Widget buildFirstNameTextField() {
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
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "Enter First Name";
              // MyLocalizations.of(context).enterFullName;
            } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value!)) {
              return "Please Enter Valid Firstname";
              //  MyLocalizations.of(context).pleaseEnterValidFullName;
            } else {
              return null;
            }
          },
          onSaved: (String? value) {
            firstName = value;
          },
          decoration: InputDecoration(
            hintText: "First Name",
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

  Widget buildLastNameTextField() {
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
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "Enter Last Name";
              // MyLocalizations.of(context).enterFullName;
            } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value!)) {
              return "Please Enter Valid Lastname";
              //  MyLocalizations.of(context).pleaseEnterValidFullName;
            } else {
              return null;
            }
          },
          onSaved: (String? value) {
            lastName = value;
          },
          decoration: InputDecoration(
            hintText: "Last Name",
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

  Widget buildEmailTextField() {
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
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "Enter Your Email";
            } else if (!RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value!)) {
              return "Please Enter Valid Email";
              // MyLocalizations.of(context).pleaseEnterValidEmail;
            } else {
              return null;
            }
          },
          onSaved: (String? value) {
            email = value;
          },
          decoration: InputDecoration(
            hintText: "Email ID",
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
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: textpoppinsRegular(),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: const TextStyle(color: Color(0xFFF44242)),
            contentPadding: const EdgeInsets.all(10),
            suffixIcon: InkWell(
              onTap: () {
                if (mounted) {
                  setState(() {
                    passwordVisible1 = !passwordVisible1;
                  });
                }
              },
              child: const Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
          ),
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "enter Password";
              // MyLocalizations.of(context).enterPassword;
            } else if ((value?.length ?? 0) < 6) {
              return "please Enter Min 6 Digit Password";
              // MyLocalizations.of(context)
              //     .pleaseEnterMin6DigitPassword;
            } else {
              return null;
            }
          },
          controller: _passwordTextController,
          onSaved: (String? value) {
            password1 = value;
          },
          obscureText: passwordVisible1,
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
          decoration: InputDecoration(
            hintText: "Confirm Password",
            hintStyle: textpoppinsRegular(),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: const TextStyle(color: Color(0xFFF44242)),
            contentPadding: const EdgeInsets.all(10),
            suffixIcon: InkWell(
              onTap: () {
                if (mounted) {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                }
              },
              child: const Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
          ),
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "enter Password";
              // MyLocalizations.of(context).enterPassword;
            } else if ((value?.length ?? 0) < 6) {
              return "please Enter Min 6 Digit Password";
              // MyLocalizations.of(context)
              //     .pleaseEnterMin6DigitPassword;
            } else if (_passwordTextController.text != value) {
              return "Password doesn't match";
              // MyLocalizations.of(context).passwordsdonotmatch;
            } else {
              return null;
            }
          },
          onSaved: (String? value) {
            password2 = value;
          },
          obscureText: passwordVisible,
        ),
      ),
    );
  }

  Widget buildSignupButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: MaterialButton(
        onPressed: userSignup,
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
                Text("Sign Up", style: textpoppinsMediumwhite()),
                const SizedBox(
                  height: 10,
                ),
                registrationLoading
                    ? const GFLoader(
                        type: GFLoaderType.ios,
                      )
                    : const Text("")
              ],
            ),
            //  Text('Sign Up', style: textpoppinsMediumwhite()),
          ),
        ),
      ),
    );
  }

  Widget buildLinkButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: textpoppinsRegular(),
            ),
            InkWell(
              child: Text(
                "Log in",
                style: textpoppinsMediumprimary(),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LogInPage(),
                    ),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
