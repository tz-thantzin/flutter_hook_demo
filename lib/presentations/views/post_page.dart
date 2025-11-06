import 'package:flutter/material.dart';
import 'package:flutter_hook_demo/core/state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodels/post_view_model.dart';
import '../widgets/post_card.dart';

class PostPage extends HookConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postViewModel);

    final isRefreshing = useState(false);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(postViewModel.notifier).getPosts();
      });
      return null;
    }, []);

    Future<void> handleRefresh() async {
      if (isRefreshing.value) return;
      isRefreshing.value = true;
      await ref.read(postViewModel.notifier).getPosts();
      isRefreshing.value = false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: postsState.when(
          initial: () => const Center(child: Text('No posts yet')),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (posts) => RefreshIndicator(
            onRefresh: handleRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: posts?.length ?? 0,
              itemBuilder: (context, index) => PostCard(post: posts![index]),
            ),
          ),
          error: (error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${error.toString()}'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => ref.read(postViewModel.notifier).getPosts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
