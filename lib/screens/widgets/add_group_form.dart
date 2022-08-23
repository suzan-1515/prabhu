import 'package:flutter/material.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/common_widgets.dart';
import 'package:prabhu_movie_recommendation_system/style/style.dart';
import 'package:prabhu_movie_recommendation_system/utils/view_utils.dart';

import '../../service/group_service.dart';

class AddGroupForm extends StatefulWidget {
  const AddGroupForm({Key? key}) : super(key: key);

  @override
  _AddGroupFormState createState() => _AddGroupFormState();
}

class _AddGroupFormState extends State<AddGroupForm> {
  final groupNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    groupNameController.dispose();
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
                'Add Group',
                style: textpoppinssemiboldlg(),
              ),
              const Divider(
                height: 8,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: groupNameController,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length > 3) {
                    return null;
                  }
                  return 'Please enter valid name.';
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Group Name.'),
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
                          String groupName = groupNameController.value.text;
                          if (mounted) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          GroupService.createGroup(groupName).then((value) {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                                if (value.statusCode == 201) {
                                  Navigator.of(context).pop(true);
                                } else {
                                  ViewUtils.showSnackBarWithContext(
                                      'Cannot create more than 1 group at a time.',
                                      context);
                                }
                              });
                            }
                          }).catchError((onError) {
                            if (mounted) {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Unable to create group.'),
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: const Text('Create'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
