import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/add_member_form.dart';
import 'package:prabhu_movie_recommendation_system/utils/imageUtils.dart';

import '../../service/group_service.dart';
import '../../style/style.dart';
import '../../utils/view_utils.dart';
import '../widgets/add_group_form.dart';
import '../widgets/common_widgets.dart';
import '../widgets/custom_app_bar.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List membersList = List.empty(growable: true);

  String _title = 'Group';
  late int groupId = -1;

  @override
  void initState() {
    getGroup();
    super.initState();
  }

  Future<void> getGroup() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    return GroupService.getGroup().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
          if (value.statusCode == 200) {
            _title = value.data['name'];
            groupId = value.data['id'];
            if (value.data['members'] != null &&
                value.data['members'].length > 1) {
              membersList.clear();
              membersList.addAll(value.data['members']);

              //remove self/owner from the member list
              membersList.removeWhere(
                  (element) => element['id'] == value.data['owner']['id']);
            }
          }
        });
      }
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ViewUtils.showSnackBar("Group Not Found.", _scaffoldKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: bg,
        appBar: customAppBar(context, title: _title, showBackArrow: true),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondary,
          child: IconButton(
            onPressed: () {
              if (groupId == -1) {
                _showAddGroupDialog();
              } else {
                _showAddMemberDialog();
              }
            },
            icon: const Icon(CupertinoIcons.plus),
          ),
          onPressed: () {},
        ),
        body: _buildBody(context),
      );

  Widget _buildBody(BuildContext context) {
    return isLoading
        ? customLoader()
        : (membersList.isNotEmpty)
            ? buildMembersListView()
            : const NoData(text: "Members not added yet.");
  }

  buildMembersListView() => ListView.builder(
        itemCount: membersList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final Map<String, dynamic> member = membersList[index];
          return GFListTile(
            onTap: () {},
            titleText: '${member['firstName']} ${member['lastName']}',
            subTitleText: member['email'],
            avatar: GFAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  member['profilePic'] ??
                      ImageUtils.getAvatarPath(
                          member['firstName'], member['lastName'])),
            ),
            icon: _buildMemberOptionMenu(context, member),
          );
        },
      );

  Widget _buildMemberOptionMenu(
      BuildContext context, Map<String, dynamic> member) {
    return PopupMenuButton<String>(
      // Callback that sets the selected popup menu item.
      onSelected: (String item) {
        if (item == 'remove_member') {
          _memberRemoveConfirmation(context, member);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'remove_member',
          child: Text('Remove'),
        ),
      ],
    );
  }

  Future<void> _memberRemoveConfirmation(
      BuildContext context, Map<String, dynamic> member) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove member?'),
        content: const Text('Are you sure you want to remove this member?'),
        actions: [
          FlatButton(
            onPressed: () {
              if (groupId != -1) {
                GroupService.removeMember(groupId, List<int>.of([member['id']]))
                    .then((value) {
                  Navigator.of(context).pop();
                  if (value.statusCode == 200) {
                    membersList.removeWhere(
                        (element) => element['id'] == member['id']);
                    ViewUtils.showSnackBar("Member removed.", _scaffoldKey);
                  }
                }).catchError((onError) {
                  ViewUtils.showSnackBar(
                      "Error removing member.", _scaffoldKey);
                  Navigator.of(context).pop();
                });
              }
            },
            child: const Text("OK"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddMemberDialog() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) => AddMemberForm(groupId),
    ).then((value) {
      if (value != null) {
        if (value) {
          getGroup();
          ViewUtils.showSnackBar('Member added.', _scaffoldKey);
        }
      }
    });
  }

  Future<void> _showAddGroupDialog() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) => const AddGroupForm(),
    ).then((value) {
      if (value != null) {
        if (value) {
          getGroup().then((value) {
            return _showAddMemberDialog();
          });
          ViewUtils.showSnackBar('Group created.', _scaffoldKey);
        }
      }
    });
  }
}
