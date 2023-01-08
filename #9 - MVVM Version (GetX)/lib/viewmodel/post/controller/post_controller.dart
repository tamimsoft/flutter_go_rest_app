import 'package:dartz/dartz.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/controller/base_controller.dart';
import '../../../data/model/post/post.dart';
import '../../../data/model/user/user.dart';
import '../../../repository/post/post_repository.dart';

class PostController extends GetxController
    with StateMixin<List<Post>>, BaseController {
  RxInt postLength = 0.obs;

  final PostRepository postRepository;

  PostController({required this.postRepository});

  void createPost(Post post) {
    createItem(postRepository.createPost(post));
  }

  void updatePost(Post post) async {
    updateItem(postRepository.updatePost(post));
  }

  void deletePost(Post post) async {
    deleteItem(postRepository.deletePost(post));
  }

  Future<void> getPosts(User user) async {
    change(null, status: RxStatus.loading());
    Either<String, List<Post>> failureOrSuccess = (await postRepository.getPosts(user));

    failureOrSuccess.fold(
      (String failure) {
        change(null, status: RxStatus.error(failure));
      },
      (List<Post> posts) {
        postLength.value = posts.length;
        if (posts.isEmpty) {
          change(posts, status: RxStatus.empty());
        } else {
          change(posts, status: RxStatus.success());
        }
      },
    );
  }
}
