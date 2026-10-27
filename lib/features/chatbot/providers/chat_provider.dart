// lib/features/chatbot/providers/chat_provider.dart
// 역할: 공지 AI 챗봇 대화 상태(메시지·세션·스트리밍)와 대화 목록 provider.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/chat_models.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../shared/providers/app_providers.dart';
import '../../auth/providers/auth_session_provider.dart';

/// 현재 대화 화면 상태
class ChatState {
  final List<ChatMessage> messages;
  final int? sessionId;
  final bool isStreaming;

  const ChatState({
    this.messages = const [],
    this.sessionId,
    this.isStreaming = false,
  });

  ChatState copyWith({List<ChatMessage>? messages, int? sessionId, bool? isStreaming}) {
    return ChatState(
      messages: messages ?? this.messages,
      sessionId: sessionId ?? this.sessionId,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

/// 질문 전송·스트리밍 수신·세션 전환을 담당한다.
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const ChatState());

  /// 질문을 보내고, 답변 토큰을 마지막 assistant 말풍선에 이어 붙인다.
  Future<void> send(String text) async {
    final message = text.trim();
    if (message.isEmpty || state.isStreaming) return;

    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(role: 'user', content: message),
        const ChatMessage(role: 'assistant', content: ''),
      ],
      isStreaming: true,
    );

    try {
      await for (final event in _repository.sendMessage(message, sessionId: state.sessionId)) {
        if (!mounted) return;
        switch (event) {
          case ChatMetaEvent(:final sessionId, :final sources):
            state = state.copyWith(
              sessionId: sessionId,
              messages: _updateLast((m) => m.copyWith(sources: sources)),
            );
          case ChatTokenEvent(:final text):
            state = state.copyWith(
              messages: _updateLast((m) => m.copyWith(content: m.content + text)),
            );
        }
      }
    } catch (e) {
      if (!mounted) return;
      final errorText = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        messages: _updateLast((m) => m.copyWith(content: errorText, isError: true)),
      );
    } finally {
      if (mounted) state = state.copyWith(isStreaming: false);
    }
  }

  /// 대화 목록에서 고른 세션의 메시지를 불러와 이어서 대화한다.
  Future<void> openSession(int id) async {
    if (state.isStreaming) return;
    final session = await _repository.getSession(id);
    if (!mounted) return;
    state = ChatState(messages: session.messages, sessionId: session.id);
  }

  /// 새 대화를 시작한다.
  void newChat() {
    if (state.isStreaming) return;
    state = const ChatState();
  }

  /// 서버에서 세션을 삭제한다. 지금 보고 있는 대화면 새 대화로 비운다.
  Future<void> deleteSession(int id) async {
    await _repository.deleteSession(id);
    if (mounted && state.sessionId == id && !state.isStreaming) {
      state = const ChatState();
    }
  }

  List<ChatMessage> _updateLast(ChatMessage Function(ChatMessage) update) {
    final messages = [...state.messages];
    messages[messages.length - 1] = update(messages.last);
    return messages;
  }
}

/// 로그인 상태가 바뀌면(로그아웃 등) 새로 만들어져 대화가 초기화된다.
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  ref.watch(authSessionProvider.select((s) => s.valueOrNull));
  return ChatNotifier(ref.watch(chatRepositoryProvider));
});

/// 서버에 저장된 대화 목록
final chatSessionsProvider = FutureProvider.autoDispose<List<ChatSession>>((ref) {
  return ref.watch(chatRepositoryProvider).getSessions();
});

/// 챗봇 시트가 열려 있는지 (열려 있으면 플로팅 버튼을 숨긴다)
final chatSheetOpenProvider = StateProvider<bool>((ref) => false);
