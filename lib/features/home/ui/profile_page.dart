import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/features/auth/model/user_model.dart';
import 'package:face_book_clone/features/auth/register/data/register_cubit/cubit/auh_cubit.dart';
import 'package:face_book_clone/features/auth/register/logic/repos/register_repo_impl.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit.dart';
import 'package:face_book_clone/features/home/ui/edit_user.dart';
import 'package:face_book_clone/features/home/ui/widgts/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_stack/image_stack.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  UserModel? userData;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 👈 أهم جزء
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _tabController.dispose(); // 👈 تنظيف مهم
    super.dispose();
  }

  void _loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final result = await AuthRepositoryImpl().getUserData(uid);

    result.fold(
      (failure) => print("Error fetching user: ${failure.message}"),
      (user) => setState(() {
        userData = user;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = context.read<HomeCubit>();
    return Scaffold(
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
                print("user data is null");
                Text("user data is null");
              }
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PROFILE IMAGE
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/man.png'),
                ),

                Gap(20),

                // FOLLOWERS + FOLLOWING
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // FOLLOWERS
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ImageStack(
                              imageSource: ImageSource.Asset,
                              imageList: [
                                'assets/images/man.png',
                                'assets/images/woman.png',
                              ],
                              totalCount: 2,
                              imageRadius: 25,
                              imageBorderWidth: 2,
                              imageBorderColor: Colors.white,
                            ),
                            Gap(5),
                            Text(
                              "Followers",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("120"),
                          ],
                        ),
                      ),

                      // FOLLOWING
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ImageStack(
                              imageSource: ImageSource.Asset,
                              imageList: [
                                'assets/images/man.png',
                                'assets/images/woman.png',
                              ],
                              totalCount: 2,
                              imageRadius: 25,
                              imageBorderWidth: 2,
                              imageBorderColor: Colors.white,
                            ),
                            Gap(5),
                            Text(
                              "Following",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("50"),
                          ],
                        ),
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
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: kWhiteColor,
                        backgroundColor: kSeconderyColor,
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text("UnFollow"),
                          Gap(2),
                          Icon(Icons.remove),
                        ],
                      ),
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
                        "bio",
                        style: TextStyle(color: kPrimaryColor, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(10),

            // ---------------------- TAB BAR ----------------------
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "Photos"),
                Tab(text: "Posts"),
              ],
            ),

            Gap(20),

            // ---------------------- TAB VIEW ----------------------
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

                  // POSTS CARD LIST
                  StreamBuilder(
                    stream: cubit.postsStream,
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
                            return PostCard(post: post);
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
