import 'package:flutter/material.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/common_widgets.dart';
import 'package:prabhu_movie_recommendation_system/style/style.dart';
import 'package:prabhu_movie_recommendation_system/utils/view_utils.dart';

import '../../service/group_service.dart';

class AddMemberForm extends StatefulWidget {
  final int groupId;

  const AddMemberForm(this.groupId, {Key? key}) : super(key: key);

  @override
  _AddMemberFormState createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final memberEmailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    memberEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Member',
                style: textpoppinssemiboldlg(),
              ),
              const Divider(
                height: 8,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: memberEmailController,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return null;
                  }
                  return 'Please enter valid email.';
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Member Email'),
              ),
              const SizedBox(
                height: 12,
              ),
              (isLoading)
                  ? customLoader()
                  : OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String memberEmail = memberEmailController.value.text;
                          if (mounted) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          GroupService.addMember(widget.groupId,
                              List<String>.of([memberEmail])).then((value) {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            if (value.statusCode == 200) {
                              if (mounted) {
                                Navigator.of(context).pop(true);
                              }
                            } else {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(),
                              //   ),
                              // );
                              ViewUtils.showSnackBarWithContext(
                                  value.data['message'], context);
                            }
                          }).catchError((onError) {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                              ViewUtils.showSnackBarWithContext(
                                  'Unable to add member', context);
                            }
                          });
                        }
                      },
                      child: const Text('Add'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
