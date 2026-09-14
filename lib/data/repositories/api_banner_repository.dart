// lib/data/repositories/api_banner_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/banner_item.dart';
import 'banner_repository.dart';

class ApiBannerRepository implements BannerRepository {
  final ApiClient _apiClient;

  ApiBannerRepository(this._apiClient);

  @override
  Future<List<BannerItem>> getBanners() async {
    try {
      final response = await _apiClient.dio.get('/api/banners');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => BannerItem.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = (data is Map && data['message'] != null) ? data['message'] as String : '배너 정보를 불러오지 못했습니다.';
      throw Exception(message);
    }
  }
}
