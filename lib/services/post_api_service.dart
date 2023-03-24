import 'package:chopper/chopper.dart';
part 'post_api_service.chopper.dart';

@ChopperApi(baseUrl: '/v4/rockets')
abstract class PostApiService extends ChopperService {
  @Get()
  Future<Response> getRockets();

  @Get(path: '/{id}')
  Future<Response> getRocketInfo(@Path('id') String id);

  // Constructor
  static PostApiService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://api.spacexdata.com'),
      services: [
        // The generated implementation
        _$PostApiService(),
      ],
      // Converts data to & from JSON and adds the application/json header.
      converter: const JsonConverter(),
    );

    return _$PostApiService(client);
  }
}
