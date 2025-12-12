import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/features/auth/model/user_model.dart';
import 'package:face_book_clone/features/auth/register/data/cubit/auth_cubit/auh_cubit.dart';
import 'package:face_book_clone/features/auth/register/logic/repos/auth_repo/register_repo_impl.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit/home_cubit.dart';
import 'package:face_book_clone/features/home/ui/edit_user.dart';
import 'package:face_book_clone/features/home/ui/widgts/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../data/repos/follow_repo/follow_repo_impl.dart';

class ProfilePage extends StatefulWidget {
  final String targetUid;
  const ProfilePage({super.key, required this.targetUid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  UserModel? userData;
  late FollowRepositoryImpl followRepository;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    followRepository = FollowRepositoryImpl(FirebaseFirestore.instance);
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadCurrentUser() async {
    final result = await AuthRepositoryImpl().getUserData(widget.targetUid);
    result.fold((failure) => print("Error fetching user: ${failure.message}"), (
      user,
    ) {
      setState(() {
        userData = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final homeCubit = context.read<HomeCubit>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (userData != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditUserPage(
                      authCubit: context.read<AuthCubit>(),
                      userModel: userData!,
                    ),
                  ),
                );
              } else {
                log("user data is null");
              }
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              await context.read<AuthCubit>().logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // PROFILE HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/man.png'),
                ),
                Gap(20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // FOLLOWERS COUNT
                      StreamBuilder<int>(
                        stream: followRepository.followersCount(
                          widget.targetUid,
                        ),
                        builder: (context, snapshot) {
                          final followers = snapshot.data ?? 0;
                          return Column(
                            children: [
                              Text(
                                "Followers",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("$followers"),
                            ],
                          );
                        },
                      ),
                      // FOLLOWING COUNT
                      StreamBuilder<int>(
                        stream: followRepository.followingCount(
                          widget.targetUid,
                        ),
                        builder: (context, snapshot) {
                          final following = snapshot.data ?? 0;
                          return Column(
                            children: [
                              Text(
                                "Following",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("$following"),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(5),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      userData?.displayName ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('@${userData?.username ?? ''}'),
                  ),
                ),
                // FOLLOW/UNFOLLOW BUTTON
                StreamBuilder<bool>(
                  stream: followRepository.isFollowingStream(
                    currentUid: currentUid,
                    targetUid: widget.targetUid,
                  ),
                  builder: (context, snapshot) {
                    bool isFollowing = snapshot.data ?? false;

                    return ElevatedButton(
                      onPressed: () async {
                        if (isFollowing) {
                          await followRepository.unFollowUser(
                            currentUid: currentUid,
                            targetUid: widget.targetUid,
                          );
                        } else {
                          await followRepository.followUser(
                            currentUid: currentUid,
                            targetUid: widget.targetUid,
                          );
                        }
                      },
                      child: Text(isFollowing ? "Unfollow" : "Follow"),
                    );
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: kSeconderyColor),
                    ),
                    foregroundColor: kSeconderyColor,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Icon(Icons.message),
                ),
              ],
            ),
            Gap(10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        userData?.bio ?? "bio",
                        style: TextStyle(color: kPrimaryColor, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(10),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "Photos"),
                Tab(text: "Posts"),
              ],
            ),
            Gap(20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  GridView.builder(
                    itemCount: 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/man.png"),
                          ),
                        ),
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: homeCubit.postsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else if (snapshot.hasData) {
                        final posts = snapshot.data!;
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return PostCard(
                              post: post,
                              currentUid: currentUid ?? '',
                            );
                          },
                        );
                      } else {
                        return Center(child: Text("No posts found"));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
