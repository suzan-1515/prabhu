import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:prabhu_movie_recommendation_system/screens/auth/login.dart';

import '../../../service/auths_service.dart';
import '../../../service/common.dart';
import '../../../style/style.dart';
import '../../../utils/imageUtils.dart';
import '../../auth/changepassword.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_settings.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isLoading = false;
  late Map<String, dynamic> userDetails;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: white,
        appBar: customAppBar(context, title: 'Account', showBackArrow: true),
        body: isLoading
            ? customLoader()
            : (userDetails.isNotEmpty)
                ? Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        decoration: const BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.black54, blurRadius: 1)
                            ]),
                      ),
                      Positioned(
                        child: buildAccountDetails(),
                      ),
                    ],
                  )
                : const NoData(),
      );

  Widget buildAccountDetails() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            GFAvatar(
              backgroundColor: bg,
              shape: GFAvatarShape.circle,
              size: 100,
              child: Container(
                  decoration: const BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black45, blurRadius: 1)
                      ]),
                  child: (userDetails['profilePic'] != null)
                      ? Center(
                          child: SizedBox(
                            height: 130,
                            width: 130,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  ImageUtils.getAvatarPathOfApi(
                                      userDetails['profilePic'])),
                            ),
                          ),
                        )
                      : const Center(
                          child: SizedBox(
                            height: 130,
                            width: 130,
                            child: CircleAvatar(),
                          ),
                        )),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                '${userDetails['firstName']} ${userDetails['lastName']} ',
                style: textpoppinsboldblack(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  bottom: 15, top: 20, left: 10, right: 10),
              height: 40,
              child: MaterialButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileSetting(),
                  ),
                ).then((value) => getUserInfo()),
                color: white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Profile Settings', style: textpoppinsmediummdd()),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 25,
                        color: primary,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
              height: 40,
              child: MaterialButton(
                onPressed: () {
                  // Common.removeToken();
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (BuildContext context) => LogInPage(),
                  //     ),
                  //     (Route<dynamic> route) => false);
                },
                color: white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),

                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassword(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Change Password', style: textpoppinsmediummdd()),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          size: 25,
                          color: primary,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
              child: MaterialButton(
                onPressed: () => launchURL("https://google.com"),
                color: white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Help', style: textpoppinsmediummdd()),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 25,
                        color: primary,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
              child: MaterialButton(
                onPressed: () {
                  Common.removeToken();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LogInPage(),
                      ),
                      (Route<dynamic> route) => false);
                },
                color: white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Logout', style: textpoppinsmediummdd()),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 25,
                        color: primary,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      );

  void getUserInfo() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    AuthService.getUserInfo().then((value) {
      if (mounted) {
        setState(() {
          userDetails = value.data;
          isLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}
