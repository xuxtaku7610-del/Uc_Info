// lib/features/home/providers/banner_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/banner_item.dart';
import '../../../data/repositories/banner_repository.dart';
import '../../../shared/providers/app_providers.dart';

class BannerState {
  final List<BannerItem> banners;
  final bool isLoading;
  final String? errorMessage;

  const BannerState({
    this.banners = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  BannerState copyWith({
    List<BannerItem>? banners,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BannerState(
      banners: banners ?? this.banners,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class BannerNotifier extends StateNotifier<BannerState> {
  final BannerRepository _repository;

  BannerNotifier(this._repository) : super(const BannerState()) {
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final allBanners = await _repository.getBanners();
      // "ACTIVE" 상태인 배너만 필터링
      final activeBanners = allBanners.where((b) => b.status == 'ACTIVE').toList();
      state = state.copyWith(banners: activeBanners, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '배너를 불러오지 못했습니다.',
      );
    }
  }
}

final bannerProvider = StateNotifierProvider.autoDispose<BannerNotifier, BannerState>((ref) {
  final repository = ref.watch(bannerRepositoryProvider);
  return BannerNotifier(repository);
});
