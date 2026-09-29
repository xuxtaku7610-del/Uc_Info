import '../models/banner_item.dart';

abstract class BannerRepository {
  Future<List<BannerItem>> getBanners();
}
