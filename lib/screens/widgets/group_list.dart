import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:prabhu_movie_recommendation_system/screens/widgets/member_list.dart';
import 'package:prabhu_movie_recommendation_system/utils/imageUtils.dart';

import '../../service/group_service.dart';
import '../../style/style.dart';
import '../../utils/view_utils.dart';
import '../widgets/add_group_form.dart';
import '../widgets/common_widgets.dart';
import '../widgets/custom_app_bar.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List groupsList = List.empty(growable: true);

  @override
  void initState() {
    getGroups();
    super.initState();
  }

  Future<void> getGroups() {
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
            if (value.data['groups'] != null &&
                value.data['groups'].length > 0) {
              groupsList.clear();
              groupsList.addAll(value.data['groups']);

              //remove self/owner from the member list
              // groupsList.removeWhere(
              //     (element) => element['id'] == value.data['owner']['id']);
            }
          }
        });
      }
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ViewUtils.showSnackBar("Groups Not Found.", _scaffoldKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: bg,
        appBar: customAppBar(context, title: 'Groups', showBackArrow: true),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondary,
          child: IconButton(
            onPressed: () {
              _showAddGroupDialog();
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
        : (groupsList.isNotEmpty)
            ? buildGroupsListView()
            : const NoData(text: "Groups not created yet.");
  }

  buildGroupsListView() => ListView.builder(
        itemCount: groupsList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final Map<String, dynamic> group = groupsList[index];
          return GFListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MemberList(group: group)),
            ).then((value) {
              if (value != null && value) getGroups();
            }),
            titleText: '${group['name']}',
            subTitleText: 'By: ${group['owner']['email']}',
            avatar: GFAvatar(
              backgroundImage: CachedNetworkImageProvider((group['owner']
                          ['profilePic'] !=
                      null)
                  ? ImageUtils.getAvatarPathOfApi(group['owner']['profilePic'])
                  : ImageUtils.getAvatarPath(
                      group['owner']['firstName'], group['owner']['lastName'])),
            ),
            icon: _buildGroupOptionMenu(context, group),
          );
        },
      );

  Widget _buildGroupOptionMenu(
      BuildContext context, Map<String, dynamic> member) {
    return PopupMenuButton<String>(
      // Callback that sets the selected popup menu item.
      onSelected: (String item) {
        if (item == 'remove_group') {
          _groupRemoveConfirmation(context, member).then((value) {
            if (mounted) {
              setState(() {});
            }
          });
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'remove_group',
          child: Text('Remove'),
        ),
      ],
    );
  }

  Future<void> _groupRemoveConfirmation(
      BuildContext context, Map<String, dynamic> group) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove group?'),
        content: const Text('Are you sure you want to remove this group?'),
        actions: [
          FlatButton(
            onPressed: () {
              GroupService.deleteGroup(group['id']).then((value) {
                if (value.statusCode == 200) {
                  groupsList
                      .removeWhere((element) => element['id'] == group['id']);
                  ViewUtils.showSnackBar("Group deleted.", _scaffoldKey);
                } else {
                  ViewUtils.showSnackBar(value.data['message'], _scaffoldKey);
                }

                Navigator.of(context).pop();
              }).catchError((onError) {
                ViewUtils.showSnackBar(onError['message'], _scaffoldKey);
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
          getGroups();
          ViewUtils.showSnackBar('Group created.', _scaffoldKey);
        }
      }
    });
  }
}
