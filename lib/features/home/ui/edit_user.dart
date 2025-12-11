import 'dart:typed_data';
import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/features/auth/model/user_model.dart';
import 'package:face_book_clone/features/auth/register/data/cubit/auth_cubit/auh_cubit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditUserPage extends StatefulWidget {
  final UserModel userModel;
  final AuthCubit authCubit;

  const EditUserPage({
    super.key,
    required this.userModel,
    required this.authCubit,
  });

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late UserModel editableUser;
  late TextEditingController displayController;
  late TextEditingController usernameController;
  late TextEditingController bioController;
  Uint8List? file;

  @override
  void initState() {
    super.initState();
    // نسخ البيانات لتعديلها
    editableUser = UserModel(
      uid: widget.userModel.uid,
      email: widget.userModel.email,
      displayName: widget.userModel.displayName,
      username: widget.userModel.username,
      bio: widget.userModel.bio,
      profilePic: widget.userModel.profilePic,
      followers: widget.userModel.followers,
      following: widget.userModel.following,
    );

    displayController = TextEditingController(text: editableUser.displayName);
    usernameController = TextEditingController(text: editableUser.username);
    bioController = TextEditingController(text: editableUser.bio);
  }

  @override
  void dispose() {
    displayController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Gap(20),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: file != null
                        ? MemoryImage(file!)
                        : AssetImage('assets/images/man.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: kSeconderyColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        // هنا ممكن تضيف اختيار صورة من الهاتف
                      },
                      icon: Icon(Icons.edit, color: kWhiteColor),
                    ),
                  ),
                ],
              ),
            ),
            Gap(20),
            TextFormField(
              controller: displayController,
              decoration: InputDecoration(
                fillColor: kWhiteColor,
                filled: true,
                prefixIcon: Icon(Icons.person),
                labelText: "Display Name",
                labelStyle: TextStyle(color: kPrimaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (val) => editableUser.displayName = val,
            ),
            Gap(20),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                fillColor: kWhiteColor,
                filled: true,
                prefixIcon: Icon(Icons.person_outline),
                labelText: "Username",
                labelStyle: TextStyle(color: kPrimaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (val) => editableUser.username = val,
            ),
            Gap(20),
            TextFormField(
              controller: bioController,
              decoration: InputDecoration(
                fillColor: kWhiteColor,
                filled: true,
                prefixIcon: Icon(Icons.info),
                labelText: "Bio",
                labelStyle: TextStyle(color: kPrimaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (val) => editableUser.bio = val,
            ),
            Gap(20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSeconderyColor,
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      widget.authCubit.updateProfile(editableUser);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Profile updated successfully!"),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('UPDATE', style: TextStyle(color: kWhiteColor)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
