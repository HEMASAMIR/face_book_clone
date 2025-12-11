import 'dart:io';
import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/features/home/data/home_model/home_model.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit/home_cubit.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit/home_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  File? pickedImage;
  TextEditingController desCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';
    final displayName = user?.displayName ?? 'Unknown';
    final pic = user?.photoURL ?? 'assets/images/man.png';
    final username = displayName;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Post"),
        actions: [
          TextButton(
            onPressed: () async {
              if (pickedImage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please pick an image first!")),
                );
                return;
              }

              // رفع الصورة على Cloudinary
              await context.read<HomeCubit>().uploadPickedImage(pickedImage!);

              final state = context.read<HomeCubit>().state;
              await upload(state, uid, displayName, pic, username, context);
            },
            child: Text("Post"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: pic.startsWith('http')
                      ? NetworkImage(pic)
                      : AssetImage(pic) as ImageProvider,
                ),
                Gap(20),
                Expanded(
                  child: TextField(
                    controller: desCon,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Type here ...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  ImageProvider imageProvider = AssetImage(
                    'assets/images/man.png',
                  );

                  if (pickedImage != null) {
                    imageProvider = FileImage(pickedImage!);
                  }

                  if (state is ImagePickFailure) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    });
                  }

                  return Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: kSeconderyColor,
                    padding: EdgeInsets.all(20),
                  ),
                  onPressed: () async {
                    await context.read<HomeCubit>().pickFromCamera();
                    final state = context.read<HomeCubit>().state;
                    if (state is ImagePicked) pickedImage = state.image.file;
                    setState(() {});
                  },
                  child: Icon(Icons.camera, color: Colors.white),
                ),
                Gap(20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: kSeconderyColor,
                    padding: EdgeInsets.all(20),
                  ),
                  onPressed: () async {
                    await context.read<HomeCubit>().pickFromGallery();
                    final state = context.read<HomeCubit>().state;
                    if (state is ImagePicked) pickedImage = state.image.file;
                    setState(() {});
                  },
                  child: Icon(Icons.photo_library, color: Colors.white),
                ),
              ],
            ),
            Gap(100),
          ],
        ),
      ),
    );
  }

  Future<void> upload(
    HomeState state,
    String uid,
    String displayName,
    String pic,
    String username,
    BuildContext context,
  ) async {
    if (state is ImageUploadSuccess) {
      final post = PostModel(
        description: desCon.text,
        uid: uid,
        displayName: displayName,
        profilePic: pic,
        username: username,
        postImage: state.url,
        date: DateTime.now(),
        like: [],
        postId: Uuid().v4(),
      );

      await context.read<HomeCubit>().uploadPost(post);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Post uploaded successfully!")));
    } else if (state is ImageUploadFailure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: ${state..error}")));
    }
  }
}
