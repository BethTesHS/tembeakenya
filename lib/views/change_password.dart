import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
// import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
// import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/model/user_model.dart';

class ChangePasswordView extends StatefulWidget {
  final dynamic currentUser;
  const ChangePasswordView({super.key, required this.currentUser});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  Uint8List? pickedImage;
  late String displayUrl;
  User? user;

  late final TextEditingController _newPassword;
  late final TextEditingController _currentPassword;
  late final TextEditingController _confirmPassword;

  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  String profileImageID = "defaultProfilePic";

  @override
  void initState() {
    user = widget.currentUser;

    displayUrl = '';
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });

    _newPassword = TextEditingController();
    _currentPassword = TextEditingController();
    _confirmPassword = TextEditingController();

    super.initState();
  }

  void pick() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      pickedImage = img;
    });
  }

  @override
  void dispose() {
    _newPassword.dispose();
    _currentPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // user = widget.currentUser;

    // theUsername = user!.username.toString();

    // NavigationService navigationService = NavigationService(router);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorsUtil.backgroundColorDark,
            title: const Text(
              'Change Password',
              style: TextStyle(color: ColorsUtil.textColorDark),
            )),
        body: SingleChildScrollView(
            child:
                Column(
                crossAxisAlignment: CrossAxisAlignment.end, 
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          const Divider(
            height: 25,
            color: ColorsUtil.secondaryColorDark,
            indent: 12,
            endIndent: 12,
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 59, 21),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current Password',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                      ],
                    ),
                    TextField(
                      controller: _currentPassword,
                      onChanged: (value) {
                        user?.username = value;
                        currentPassword = value;
                      },
                    ),
                  ])),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 59, 21),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('New Password',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                      ],
                    ),
                    TextField(
                      controller: _newPassword,
                      onChanged: (value) {
                        user?.username = value;
                        newPassword = value;
                      },
                    ),
                  ])),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 59, 21),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Confirm New Password',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                      ],
                    ),
                    TextField(
                      controller: _confirmPassword,
                      onChanged: (value) {
                        user?.username = value;
                        confirmPassword = value;
                      },
                    ),
                  ])),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  minimumSize: const Size(120, 50),
                  foregroundColor: ColorsUtil.textColorDark,
                  backgroundColor: ColorsUtil.secondaryColorDark,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                onPressed: () {
                  if (pickedImage != null) {
                    uploadPic(pickedImage!, user?.username);
                  }

                  // final username = _username.text.isNotEmpty
                  //     ? _username.text
                  //     : user!.username;

                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
                child: const Text('Update'),
              ))
        ])));
  }
}
