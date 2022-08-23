import 'dart:io';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:prabhu_movie_recommendation_system/utils/imageUtils.dart';
import 'package:prabhu_movie_recommendation_system/utils/view_utils.dart';

import '../../service/auths_service.dart';
import '../../style/style.dart';
import '../../utils/extensions.dart';
import 'common_widgets.dart';
import 'custom_app_bar.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false,
      isSubmitLoading = false,
      isPicUploading = false,
      profileEdit = false;

  late String firstName, lastName, email;
  late Map<String, dynamic> userDetails = {};
  XFile? image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  updateUserProfile() async {
    final FormState? form = _formKey.currentState;

    if (!(form?.validate() ?? false)) {
      return;
    } else {
      form?.save();
      if (mounted) {
        setState(() {
          profileEdit = true;
          isSubmitLoading = true;
        });
      }
      final Map<String, dynamic> body = {
        "firstName": firstName,
        "lastName": lastName,
      };
      await AuthService.updateUserProfile(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isSubmitLoading = false;
              profileEdit = false;
            });
          }
          if (onValue.statusCode == 200) {
            userDetails['firstName'] = onValue.data['firstName'];
            userDetails['lastName'] = onValue.data['lastName'];
            ViewUtils.showSnackBar('Profile Updated.', _scaffoldKey);
          } else {
            ViewUtils.showSnackBar(onValue.data['message'], _scaffoldKey);
          }
        } catch (error, stackTrace) {
          if (mounted) {
            setState(() {
              isSubmitLoading = false;
              profileEdit = false;
            });
          }
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isSubmitLoading = false;
            profileEdit = false;
          });
        }
      });
    }
  }

  selectGallery() async {
    image = (await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 90));
    if (mounted) {
      setState(() {
        isPicUploading = true;
      });
    }
    imageUpload(image);
  }

  selectCamera() async {
    // ignore: deprecated_member_use
    image =
        (await _picker.pickImage(source: ImageSource.camera, imageQuality: 90));
    if (mounted) {
      setState(() {
        isPicUploading = true;
      });
    }
    imageUpload(image);
  }

  imageUpload(_imageFile) async {
    Navigator.pop(context);

    var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
    int length = await _imageFile.length();

    AuthService.uploadAvatar(stream, length, _imageFile.path).then((value) {
      if (mounted) {
        setState(() {
          isPicUploading = false;
          if (value.statusCode == 201) {
            userDetails['profilePic'] = value.data['profilePic'];
          } else {
            ViewUtils.showSnackBar(value.data['message'], _scaffoldKey);
          }
        });
      }
    }).catchError((error, stackTrace) {
      if (mounted) {
        setState(() {
          isPicUploading = false;
        });
        print(stackTrace);
        ViewUtils.showSnackBar('Error uploading image.', _scaffoldKey);
      }
    });
  }

  selectImage() async => showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(24.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Select",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: TextDecoration.none),
                  ),
                ),
                GFButton(
                  onPressed: selectCamera,
                  type: GFButtonType.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        "Take Photo",
                      ),
                      Icon(Icons.camera_alt),
                    ],
                  ),
                ),
                GFButton(
                  onPressed: selectGallery,
                  type: GFButtonType.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        "Choose From Photos",
                      ),
                      Icon(Icons.image),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
        appBar: customAppBar(context,
            title: 'Profile Setting', showBackArrow: true),
        body: isLoading
            ? customLoader()
            : (userDetails.isNotEmpty)
                ? Form(
                    key: _formKey,
                    child: Stack(
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
                        Positioned(child: buildAccountDetails())
                      ],
                    ),
                  )
                : const NoData(),
      );

  Widget buildAccountDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: Stack(
              children: toList(() sync* {
                if (!isPicUploading) {
                  if (userDetails['profilePic'] == null) {
                    yield Center(
                      child: SizedBox(
                        height: 130,
                        width: 130,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            ImageUtils.getAvatarPath(userDetails['firstName'],
                                userDetails['lastName']),
                          ),
                        ),
                      ),
                    );
                  } else {
                    yield Center(
                      child: SizedBox(
                        height: 130,
                        width: 130,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            ImageUtils.getAvatarPathOfApi(
                                userDetails['profilePic']),
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  yield customLoader() as Widget;
                  yield Center(
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: (image != null)
                          ? CircleAvatar(
                              backgroundImage: FileImage(File(image!.path)),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                ImageUtils.getAvatarPath(
                                    userDetails['firstName'],
                                    userDetails['lastName']),
                              ),
                            ),
                    ),
                  );
                }
                yield Positioned(
                  left: 216,
                  top: 164,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildFirstNameField(),
          buildLastNameField(),
          const SizedBox(
            height: 10,
          ),
          buildEmailField(),
          const SizedBox(
            height: 10,
          ),
          if (profileEdit) buildSubmitForm(),
        ],
      ),
    );
  }

  Container buildSubmitForm() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      child: MaterialButton(
        onPressed: updateUserProfile,
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
                Text("Submit", style: textpoppinsMediumwhite()),
                const SizedBox(
                  height: 10,
                ),
                isSubmitLoading
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

  Container buildEmailField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      child: TextFormField(
        enabled: false,
        initialValue: userDetails['email'] ?? "",
        style: textpoppinsRegularBlack(),
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 10.0,
            bottom: 10.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
        ),
      ),
    );
  }

  Container buildLastNameField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      child: TextFormField(
        initialValue: userDetails['lastName'] ?? "",
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 10.0,
            bottom: 10.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
        ),
        onChanged: (value) {
          lastName = value;
          profileEdit = true;
        },
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return "Enter Last Name";
          } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value!)) {
            return "Please Enter Valid Last Name";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Container buildFirstNameField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      child: TextFormField(
        initialValue: userDetails['firstName'] ?? "",
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 10.0,
            bottom: 10.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
        ),
        onChanged: (value) {
          firstName = value;
          profileEdit = true;
        },
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return "Enter First Name";
          } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value!)) {
            return "Please Enter Valid First Name";
          } else {
            return null;
          }
        },
      ),
    );
  }

  List<Widget> picUploadingAvatarWidgets() => List<Widget>.of([
        Center(
          child: SizedBox(
            height: 130,
            width: 130,
            child: (image != null)
                ? CircleAvatar(
                    backgroundImage: FileImage(File(image!.path)),
                  )
                : const CircleAvatar(),
          ),
        ),
        customLoader(),
      ]);

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
          firstName = userDetails['firstName'];
          lastName = userDetails['lastName'];
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
