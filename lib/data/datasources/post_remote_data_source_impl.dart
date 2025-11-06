import 'package:flutter_hook_demo/data/datasources/post_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_service.dart';
import '../responses/post_response.dart';

final postRemoteDataSourceImpl = Provider.autoDispose<PostRemoteDataSourceImpl>(
  (ref) => PostRemoteDataSourceImpl(apiService: ref.watch(apiServiceProvider)),
);

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiService apiService;

  PostRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<PostResponse>> fetchPosts() async {
    final data = await apiService.getPosts();
    return data;
  }
}
