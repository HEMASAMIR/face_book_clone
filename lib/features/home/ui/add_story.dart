// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:face_book_clone/core/colors/app_colors.dart';
// import 'package:face_book_clone/features/auth/model/user_model.dart';
// import 'package:face_book_clone/features/auth/register/logic/repos/auth_repo/register_repo_impl.dart';
// import 'package:face_book_clone/features/home/data/home_repo/stories_repo/stories_repo_impl.dart';
// import 'package:face_book_clone/features/home/logic/story_cubit/story_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';

// class AddStory extends StatefulWidget {
//   final String currentUid;
//   const AddStory({super.key, required this.currentUid});

//   @override
//   State<AddStory> createState() => _AddStoryState();
// }

// class _AddStoryState extends State<AddStory> {
//   UserModel? userData;
//   late StoriesRepositoryImpl storiesRepositoryImpl;

//   @override
//   void initState() {
//     super.initState();

//     storiesRepositoryImpl = StoriesRepositoryImpl(FirebaseFirestore.instance);
//     _loadCurrentUser();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _loadCurrentUser() async {
//     final result = await AuthRepositoryImpl().getUserData(widget.currentUid);
//     result.fold((failure) => print("Error fetching user: ${failure.message}"), (
//       user,
//     ) {
//       setState(() {
//         userData = user;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Story"),
//         actions: [
//           BlocBuilder<StoryCubit, StoryState>(
//             builder: (context, state) {
//               return ElevatedButton(onPressed: () {}, child: Text("Post"));
//             },
//           ),
//         ],
//       ),
//       body: BlocProvider(
//         create: (context) =>
//             StoryCubit(StoriesRepositoryImpl(FirebaseFirestore.instance)),
//         child: BlocConsumer<StoryCubit, StoryState>(
//           listener: (context, state) {
//             if (state is ImagePickFailure) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.error)));
//             }
//             if (state is ImageUploadFailure) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.error)));
//             }
//             if (state is StoryCreated) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Story Created Successfully!")),
//               );
//             }
//           },
//           builder: (context, state) {
//             File? pickedImage;
//             if (state is ImagePicked) {
//               pickedImage = state.file; // <-- هنا استخدمنا 'file' بدل 'image'
//             }

//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundImage: AssetImage('assets/images/man.png'),
//                       ),
//                       Gap(10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [Text('displayName'), Text("@username")],
//                       ),
//                       Spacer(),
//                       Text(DateTime.now().toString()),
//                     ],
//                   ),
//                   Gap(12),
//                   Expanded(
//                     child: Container(
//                       width: double.infinity,
//                       margin: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         image: DecorationImage(
//                           fit: BoxFit.cover,
//                           image: pickedImage != null
//                               ? FileImage(pickedImage)
//                               : AssetImage("assets/images/man.png")
//                                     as ImageProvider,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Gap(20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: CircleBorder(),
//                           backgroundColor: kSeconderyColor,
//                           padding: EdgeInsets.all(20),
//                         ),
//                         onPressed: () =>
//                             context.read<StoryCubit>().pickFromCamera(),
//                         child: Icon(Icons.camera, color: Colors.white),
//                       ),
//                       Gap(20),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: CircleBorder(),
//                           backgroundColor: kSeconderyColor,
//                           padding: EdgeInsets.all(20),
//                         ),
//                         onPressed: () =>
//                             context.read<StoryCubit>().pickFromGallery(),
//                         child: Icon(Icons.photo_library, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
