import 'package:dio/dio.dart';
import 'package:flutter_hook_demo/data/responses/post_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

final apiServiceProvider = Provider.autoDispose<ApiService>(
  (ref) => ApiService(
    Dio(
      BaseOptions(
        baseUrl: "https://jsonplaceholder.typicode.com",
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    ),
  ),
);

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class _RetrofitClient {
  factory _RetrofitClient(Dio dio) = __RetrofitClient;

  @GET("/posts")
  Future<List<PostResponse>> getPosts();

  @GET("/posts/{id}")
  Future<PostResponse> getPostById(@Path("id") int id);
}

class ApiService {
  late final _RetrofitClient _client;

  ApiService(Dio dio) {
    _client = _RetrofitClient(dio);
  }

  Future<List<PostResponse>> getPosts() async {
    return await _client.getPosts();
  }

  Future<PostResponse> getPostById(int id) async {
    return await _client.getPostById(id);
  }
}
