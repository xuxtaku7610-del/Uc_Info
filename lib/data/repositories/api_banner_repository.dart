// lib/data/repositories/api_banner_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import '../models/banner_item.dart';
import 'banner_repository.dart';

class ApiBannerRepository implements BannerRepository {
  final ApiClient _apiClient;

  ApiBannerRepository(this._apiClient);

  @override
  Future<List<BannerItem>> getBanners() async {
    try {
      final response = await _apiClient.dio.get('/api/banners');

      final rawData = response.data;
      if (rawData is! List) {
        throw Exception('예상치 못한 응답 형식입니다.');
      }
      final List<dynamic> data = rawData;

      try {
        return data.map((json) => BannerItem.fromJson(json)).toList();
      } catch (e) {
        throw Exception('데이터 형식이 올바르지 않습니다.');
      }
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '배너 정보를 불러오지 못했습니다.'));
    }
  }
}
