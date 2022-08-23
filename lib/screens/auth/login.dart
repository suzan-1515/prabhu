import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:prabhu_movie_recommendation_system/screens/auth/signup.dart';
import 'package:prabhu_movie_recommendation_system/service/constants.dart';
import 'package:provider/provider.dart';

import '../../service/auths_service.dart';
import '../../service/common.dart';
import '../../style/style.dart';
import '../../utils/view_utils.dart';
import '../../view_model/app_model.dart';
import '../pages/layout.dart';
import '../widgets/common_widgets.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    Key? key,
  }) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isUserLoading = false,
      registrationLoading = false,
      value = false,
      passwordVisible = true;
  late String? email, password;
  bool _obscureText = true, isChecked = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  userLogin() async {
    AppModel appModel = Provider.of<AppModel>(context, listen: false);
    final form = _formKeyForLogin.currentState;
    if (form?.validate() ?? false) {
      form?.save();
      if (appModel.isOnline) {
        if (mounted) {
          setState(() {
            isUserLoading = true;
          });
        }
        Map<String, dynamic> body = {
          "email": email?.toLowerCase(),
          "password": password
        };
        await AuthService.signIn(body).then((onValue) async {
          try {
            if (mounted) {
              setState(() {
                isUserLoading = false;
              });
            }
            if (onValue.data['statusCode'] == null) {
              if (onValue.data['token'] != null) {
                await Common.setToken(onValue.data['token']);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Home(),
                    ),
                    (Route<dynamic> route) => false);
              } else {
                ViewUtils.showSnackBar("Invalid User", _scaffoldKey);
              }
            } else {
              ViewUtils.showSnackBar(onValue.data['message'], _scaffoldKey);
            }
          } catch (error) {
            if (mounted) {
              setState(() {
                isUserLoading = false;
              });
            }
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              isUserLoading = false;
            });
          }
        });
      } else {
        ViewUtils.showSnackBar(
            Constants.internetConnectionUnavailable, _scaffoldKey);
      }
    } else {
      if (mounted) {
        setState(() {
          isUserLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppModel>(context, listen: true).checkConnectivity();
    AppModel appModel = Provider.of<AppModel>(context, listen: true);
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          appModel.isOnline
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: const NoInternet(),
                ),
        ],
      ),
    );
  }

  Widget buildLoginPageForm() {
    return Form(
      key: _formKeyForLogin,
      child: Theme(
        data: ThemeData(
          brightness: Brightness.dark,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              buildWelcomeTextLogo(),
              buildWelcomeText(),
              const SizedBox(height: 50),
              buildEmailTextField(),
              buildPasswordTextField(),
              const SizedBox(height: 30),
              buildLoginButton(),
              const SizedBox(height: 20),
              buildForgotPasswordLink(),
              const SizedBox(height: 40),
              buildLinkButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWelcomeText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          "Log In",
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
          onSaved: (String? value) {
            email = value;
          },
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "Enter Your Email";
              //  MyLocalizations.of(context).enterYourEmail;
            } else if (!RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value!)) {
              return "Please Enter Valid Email";
              // MyLocalizations.of(context).pleaseEnterValidEmail;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            hintText: "Email Id",
            hintStyle: textpoppinsRegular(),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: const TextStyle(color: Color(0xFFF44242)),
            contentPadding: const EdgeInsets.all(10),
            // enabledBorder: const OutlineInputBorder(
            //   borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            // ),
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
          onSaved: (String? value) {
            password = value;
          },
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return "Enter Password";
              //  MyLocalizations.of(context).enterPassword;
            } else if ((value?.length ?? 0) < 6) {
              return "Please Enter Min 6 Digit Password";
              // MyLocalizations.of(context).pleaseEnterMin6DigitPassword;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            hintText: "Password",
            suffixIcon: InkWell(
              onTap: _toggle,
              child: _obscureText
                  ? const Icon(Icons.remove_red_eye, color: Colors.black54)
                  : const Icon(Icons.remove_red_eye, color: Colors.black26),
            ),
            hintStyle: textpoppinsRegular(),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: const TextStyle(color: Color(0xFFF44242)),
            contentPadding: const EdgeInsets.all(10),
            // enabledBorder: const OutlineInputBorder(
            //   borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            // ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
          ),
          obscureText: _obscureText,
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: MaterialButton(
        onPressed: userLogin,
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
                Text("Log In", style: textpoppinsMediumwhite()),
                const SizedBox(
                  height: 10,
                ),
                isUserLoading
                    ? const GFLoader(
                        type: GFLoaderType.ios,
                      )
                    : const Text("")
              ],
            ),
            //  Text('Log In', style: textpoppinsMediumwhite()),
          ),
        ),
      ),
    );
  }

  Widget buildForgotPasswordLink() {
    AppModel appModel = Provider.of<AppModel>(context, listen: false);
    return InkWell(
      onTap: () {
        if (appModel.isOnline) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ForgotPassword(),
          //   ),
          // );
        } else {
          ViewUtils.showSnackBar(
              Constants.internetConnectionUnavailable, _scaffoldKey);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: RichText(
          text: TextSpan(
            text: "Forgot Password?",
            style: textpoppinsRegularsm(),
          ),
        ),
      ),
    );
  }

  Widget buildLinkButton() {
    AppModel appModel = Provider.of<AppModel>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an Account? ",
              style: textpoppinsRegular(),
            ),
            InkWell(
              child: Text(
                "Sign up",
                style: textpoppinsMediumprimary(),
              ),
              onTap: () {
                if (appModel.isOnline) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ),
                  );
                } else {
                  ViewUtils.showSnackBar(
                      Constants.internetConnectionUnavailable, _scaffoldKey);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
