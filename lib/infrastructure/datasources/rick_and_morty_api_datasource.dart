import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:portal_gun/lib.dart';

class RickAndMortyApiDatasource implements RickAndMortyDatasource {
  RickAndMortyApiDatasource({Dio? dio}) : _dio = dio ?? _buildDio() {
    _attachLogger(_dio);
  }

  final Dio _dio;

  static Dio _buildDio() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://rickandmortyapi.com/api',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  static void _attachLogger(Dio dio) {
    final hasStatusLogger = dio.interceptors.any(
      (it) => it is _StatusCodeLogInterceptor,
    );

    if (!hasStatusLogger) {
      dio.interceptors.add(const _StatusCodeLogInterceptor());
    }
  }

  @override
  Future<CustomResponse<CharacterPageEntity>> getCharacters({
    int page = 1,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/character',
        queryParameters: {'page': page},
      );

      final data = response.data;
      if (data == null) {
        return const CustomResponse<CharacterPageEntity>(
          status: CustomResponseStatus.serverError,
        );
      }

      final dto = CharactersResponseDto.fromJson(data);

      return CustomResponse.success(CharacterPageMapper.toEntity(dto));
    } on DioException catch (e) {
      final status = CustomResponseStatus.fromCode(e.response?.statusCode);
      if (status == CustomResponseStatus.notFound) {
        return CustomResponse(
          status: status,
          data: CharacterPageEntity.empty(),
        );
      }

      return CustomResponse<CharacterPageEntity>(status: status);
    } catch (_) {
      return const CustomResponse<CharacterPageEntity>(
        status: CustomResponseStatus.unknown,
      );
    }
  }

  @override
  Future<CustomResponse<CharacterEntity>> getCharacterById(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/character/$id');

      final data = response.data;
      if (data == null) {
        return const CustomResponse<CharacterEntity>(
          status: CustomResponseStatus.serverError,
        );
      }

      final dto = CharacterDto.fromJson(data);

      return CustomResponse.success(CharacterMapper.toEntity(dto));
    } on DioException catch (e) {
      final status = CustomResponseStatus.fromCode(e.response?.statusCode);
      return CustomResponse<CharacterEntity>(status: status);
    } catch (_) {
      return const CustomResponse<CharacterEntity>(
        status: CustomResponseStatus.unknown,
      );
    }
  }
}

class _StatusCodeLogInterceptor extends Interceptor {
  const _StatusCodeLogInterceptor();

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    developer.log(
      'url: ${response.requestOptions.uri} status: ${response.statusCode}',
      name: 'RickAndMortyApi',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      'url: ${err.requestOptions.uri} status: ${err.response?.statusCode ?? 'NO_STATUS'}',
      name: 'RickAndMortyApi',
      error: err.message,
    );
    super.onError(err, handler);
  }
}
