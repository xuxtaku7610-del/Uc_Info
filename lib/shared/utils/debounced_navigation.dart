import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension DebouncedNavigation on BuildContext {
  static DateTime? _lastTapAt;
  static String? _lastPath;
  static const _debounceWindow = Duration(milliseconds: 600);
  
  void pushOnce(String path, {Object? extra}) {
    final now = DateTime.now();
    final isDuplicateTap = _lastPath == path && 
        _lastTapAt != null && 
        now.difference(_lastTapAt!) < _debounceWindow;
    
    if (isDuplicateTap) return; 
    
    _lastTapAt = now;
    _lastPath = path;
    push(path, extra: extra);
  }
}
