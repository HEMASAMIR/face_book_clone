import 'package:bloc/bloc.dart';
import 'package:face_book_clone/features/home/data/home_repo/follow_repo/follow_repo.dart';
import 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final FollowRepository repository;

  FollowCubit(this.repository) : super(FollowInitial());

  /// متابعة مستخدم
  // Future<void> followUser(String currentUid, String targetUid) async {
  //   final result = await repository.followUser(
  //     currentUid: currentUid,
  //     targetUid: targetUid,
  //   );

  //   result.fold(
  //     (error) => emit(FollowActionFailure(error)),
  //     (_) => emit(FollowStatusChanged(true)), // <- هنا
  //   );
  // }

  // Future<void> unFollowUser(String currentUid, String targetUid) async {
  //   final result = await repository.unFollowUser(
  //     currentUid: currentUid,
  //     targetUid: targetUid,
  //   );

  //   result.fold(
  //     (error) => emit(FollowActionFailure(error)),
  //     (_) => emit(FollowStatusChanged(false)), // <- هنا
  //   );
  // }

  // /// التحقق من حالة المتابعة (Stream)
  // void listenFollowStatus(String currentUid, String targetUid) {
  //   repository
  //       .isFollowingStream(currentUid: currentUid, targetUid: targetUid)
  //       .listen((isFollowing) {
  //         emit(FollowStatusChanged(isFollowing));
  //       });
  // }

  /// عدّاد الـ Followers
  // void listenFollowersCount(String uid) {
  //   repository.followersCount(uid).listen((count) {
  //     emit(FollowersCountLoaded(count));
  //   });
  // }

  // /// عدّاد الـ Following
  // void listenFollowingCount(String uid) {
  //   repository.followingCount(uid).listen((count) {
  //     emit(FollowingCountLoaded(count));
  //   });
  // }
}
