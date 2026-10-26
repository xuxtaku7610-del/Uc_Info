// lib/data/models/chat_models.dart
// 역할: 공지 AI 챗봇 메시지·출처·세션 데이터 모델과 스트리밍 이벤트 정의.

/// 답변 근거가 된 공지 출처 (챗봇 서버 meta 이벤트의 sources 항목)
class ChatSource {
  final int id;
  final String title;
  final String scopeLabel; // '학교 공지' | '학과 공지'
  final String? sourceUrl;

  const ChatSource({
    required this.id,
    required this.title,
    required this.scopeLabel,
    this.sourceUrl,
  });

  factory ChatSource.fromJson(Map<String, dynamic> json) {
    return ChatSource(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      scopeLabel: json['dept_name'] ?? '',
      sourceUrl: json['source_url'],
    );
  }
}

/// 채팅 말풍선 1개
class ChatMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  final List<ChatSource> sources;
  final bool isError;

  const ChatMessage({
    required this.role,
    required this.content,
    this.sources = const [],
    this.isError = false,
  });

  bool get isUser => role == 'user';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] ?? 'assistant',
      content: json['content'] ?? '',
    );
  }

  ChatMessage copyWith({String? content, List<ChatSource>? sources, bool? isError}) {
    return ChatMessage(
      role: role,
      content: content ?? this.content,
      sources: sources ?? this.sources,
      isError: isError ?? this.isError,
    );
  }
}

/// 대화 목록/상세 조회용 세션
class ChatSession {
  final int id;
  final String title;
  final DateTime? createdAt;
  final List<ChatMessage> messages;

  const ChatSession({
    required this.id,
    required this.title,
    this.createdAt,
    this.messages = const [],
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];
    return ChatSession(
      id: json['session_id'] ?? 0,
      title: json['title'] ?? '새 대화',
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      messages: rawMessages is List
          ? rawMessages.map((m) => ChatMessage.fromJson(m)).toList()
          : const [],
    );
  }
}

/// 챗봇 SSE 스트림 이벤트
sealed class ChatEvent {
  const ChatEvent();
}

/// 스트림 시작 시 1회: 세션 ID와 출처 목록
class ChatMetaEvent extends ChatEvent {
  final int sessionId;
  final List<ChatSource> sources;
  const ChatMetaEvent(this.sessionId, this.sources);
}

/// 답변 토큰 조각
class ChatTokenEvent extends ChatEvent {
  final String text;
  const ChatTokenEvent(this.text);
}
