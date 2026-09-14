// lib/data/models/banner_item.dart

class BannerItem {
  final int id;
  final String title;
  final String subtitle;
  final String status; // "ACTIVE" | "SCHEDULED" | "INACTIVE"

  BannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      status: json['status'] ?? 'INACTIVE',
    );
  }
}
