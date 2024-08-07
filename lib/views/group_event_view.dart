// group_event_view

import 'package:intl/intl.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/views/group_event_participants_view.dart';
import 'package:tembeakenya/views/group_event_signup.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';

// ******************* DUMMY DATABASE ******************* //
// import 'package:tembeakenya/dummy_db.dart';

class GroupEventView extends StatefulWidget {
  final dynamic user;
  final dynamic group;
  final dynamic details;
  const GroupEventView({super.key, required this.user, required this.group, required this.details});

  @override
  State<GroupEventView> createState() => _GroupEventViewState();
}

class _GroupEventViewState extends State<GroupEventView> {
  late NavigationService navigationService;

  Map<User, dynamic> users = {};

  User? selectedUser;

  String theGroupName = '';
  String theDescription = '';

  String profileImageID = '';

  int loadNum = 0;
  late bool initStateAgain;
  late List<String> displayUrl;
  // late List<bool?> isAttendee;
  late List<bool> attendingLoaded;
  bool signUp = true;
  bool loaded = false;


  userCard(int num) {
    users = widget.details['attendees'];
    var selectedUserId = users.entries.elementAt(num).value['user_id'];
    debugPrint('CHECKME: ${users.entries}');
    if (widget.user.id == selectedUserId){
      signUp = false;
    } else {
      signUp = true;
    }
    return TextButton(
        onPressed: () async {
          await CommunityController().getAUsersDetails(selectedUserId!).then(
            (user) {
              setState(() {
                selectedUser = user;
              });
            },
          );

          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParticipantDetailView(
                attendeeUser: widget.details['attendees'].entries.elementAt(num),
                selectedUser: selectedUser!,
                currentUser: widget.user,
              ),
            ),
          );
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent)),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          decoration: BoxDecoration(
            color: ColorsUtil.cardColorDark,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: ColorsUtil.secondaryColorDark),
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (displayUrl[num].isEmpty)
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        child: CircleAvatar(
                          radius: 37,
                          backgroundColor: ColorsUtil.accentColorDark,
                          child: CircleAvatar(
                            radius: 35,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        child: CircleAvatar(
                          radius: 37,
                          backgroundColor: ColorsUtil.accentColorDark,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(displayUrl[num]),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - 230,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Text(
                              users.entries.elementAt(num).key.fullName,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtil.textColorDark),
                            ),
                          ),
                          Text(
                            '@${users.entries.elementAt(num).key.username}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: ColorsUtil.accentColorDark),
                          ),
                          if (users.entries.elementAt(num).key.id == widget.group['guide_id'])
                        const Text('Guide',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.accentColorDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ));
  }

  @override
  void initState() {
    super.initState();
    navigationService = NavigationService(router);
    initStateAgain = false;

    setState(() {
      users = widget.details['attendees'];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (users.isNotEmpty) {
      if (!initStateAgain) {
        loadNum = users.length;
        displayUrl = List<String>.filled(loadNum, '');
        attendingLoaded = List<bool>.filled(loadNum, false);

        for (int i = 0; i < loadNum; i++) {
          profileImageID = users.entries.elementAt(i).key.image_id!;
          getImageUrl(profileImageID).then((String result) {
            setState(() {
              displayUrl[i] = result;
            });
          });
        }
        initStateAgain = true;
      }
    }

    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.backgroundColorDark,
        title: const Text(
          'Hike Details',
          style: TextStyle(color: ColorsUtil.textColorDark),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.all(7),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: ColorsUtil.accentColorDark),
              color: ColorsUtil.cardColorDark,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * .5,
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        widget.details['groupHikeDetails'][1],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtil.primaryColorDark,
                        ),
                      ),
                    ),
                    if(!signUp)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 45,
                      width: 100,
                    )
                    else if (signUp)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(
                            color: ColorsUtil.backgroundColorDark, width: 2),
                        color: ColorsUtil.secondaryColorDark,
                      ),
                      height: 45,
                      width: 100,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupEventSignUp(
                                      user: widget.user,
                                      details: widget.details['groupHikeDetails'],
                                      groupId: widget
                                          .details['groupHikeDetails'][2])));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorsUtil.textColorDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 15,
                  color: ColorsUtil.accentColorDark,
                ),
                Text(
                  '${widget.details['groupHikeDetails'][2]}\n',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    color: ColorsUtil.textColorDark,
                  ),
                ),
                Text(
                  'Location: ${widget.details['hike'][0][1]}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: ColorsUtil.primaryColorDark,
                  ),
                ),
                Text(
                  // DateFormat('HH:mm:ss').format
                  'Date: ${DateFormat('yyyy-mm-dd').format(DateFormat('yyyy-mm-dd').parse(widget.details['groupHikeDetails'][6]))}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: ColorsUtil.primaryColorDark,
                  ),
                ),
                Text(
                  'Hike Fee: Ksh.${widget.details['groupHikeDetails'][7]}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: ColorsUtil.primaryColorDark,
                  ),
                )
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 90 / width,
            minChildSize: 90 / width,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                // height: 0.25,
                width: width,
                decoration: BoxDecoration(
                  color: ColorsUtil.descriptionColorDark,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border.all(
                      color: ColorsUtil.backgroundColorDark, width: 1.5),
                ),

                // *********************************************************** //

                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 15),
                      height: 5,
                      child: const Icon(
                        Icons.maximize_rounded,
                        color: Color.fromARGB(112, 99, 126, 32),
                        size: 60,
                      ),
                    ),
                    Container(
                      // width: width,
                      margin: const EdgeInsets.all(25),
                      child: const Text(
                        'Participating Members',
                        style: TextStyle(
                            color: ColorsUtil.primaryColorDark,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                      height: 15,
                      color: ColorsUtil.accentColorDark,
                    ),
                    for (int i = 0; i < loadNum; i++) userCard(i),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
