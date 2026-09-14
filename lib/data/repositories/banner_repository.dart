// lib/data/repositories/banner_repository.dart

import '../models/banner_item.dart';
import '../mock/mock_data.dart';

abstract class BannerRepository {
  Future<List<BannerItem>> getBanners();
}

class MockBannerRepository implements BannerRepository {
  @override
  Future<List<BannerItem>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.banners;
  }
}
