import 'package:flutter_hook_demo/domain/usecases/post_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/post_repository_impl.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

final postUseCaseImpl = Provider.autoDispose<PostsUseCaseImpl>(
  (ref) => PostsUseCaseImpl(ref.watch(postRepositoryImpl)),
);

class PostsUseCaseImpl extends PostsUseCase {
  final PostRepository repository;

  PostsUseCaseImpl(this.repository);

  @override
  Future<List<Post>> fetchPosts() async {
    return await repository.fetchPosts();
  }
}
