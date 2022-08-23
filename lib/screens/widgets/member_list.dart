import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:prabhu_movie_recommendation_system/utils/imageUtils.dart';

import '../../service/group_service.dart';
import '../../style/style.dart';
import '../../utils/view_utils.dart';
import '../widgets/common_widgets.dart';
import '../widgets/custom_app_bar.dart';
import 'add_member_form.dart';

class MemberList extends StatefulWidget {
  final Map<String, dynamic> group;

  const MemberList({Key? key, required this.group}) : super(key: key);

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List memberList = List.empty(growable: true);

  @override
  void initState() {
    memberList.clear();
    memberList.addAll(widget.group['members']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: bg,
        appBar: customAppBar(context,
            title: widget.group['name'], showBackArrow: true),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondary,
          child: IconButton(
            onPressed: () {
              _showAddMemberDialog();
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
        : (memberList.isNotEmpty)
            ? buildMemberListView()
            : const NoData(text: "Members not added yet.");
  }

  buildMemberListView() => ListView.builder(
        itemCount: memberList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final Map<String, dynamic> member = memberList[index];
          return GFListTile(
            onTap: () {},
            titleText: '${member['firstName']} ${member['lastName']}',
            subTitleText: '${member['email']}',
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
          _memberRemoveConfirmation(context, member).then((value) {
            if (mounted) {
              setState(() {});
            }
          });
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
              GroupService.removeMember(
                      widget.group['id'], List<int>.of([member['id']]))
                  .then((value) {
                if (value.statusCode == 200) {
                  memberList
                      .removeWhere((element) => element['id'] == member['id']);
                  ViewUtils.showSnackBar("Member removed.", _scaffoldKey);
                } else {
                  ViewUtils.showSnackBar(value.data['message'], _scaffoldKey);
                }
                Navigator.of(context).pop();
              }).catchError((onError) {
                ViewUtils.showSnackBar(
                    'Unable to remove member.', _scaffoldKey);
                Navigator.of(context).pop();
              });
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
      builder: (BuildContext context) => AddMemberForm(widget.group['id']),
    ).then((value) {
      if (value != null) {
        if (value) {
          Navigator.of(context).pop(true);
          ViewUtils.showSnackBar('Member added.', _scaffoldKey);
        }
      }
    });
  }
}
