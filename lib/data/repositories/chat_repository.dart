import '../models/chat_models.dart';

abstract class ChatRepository {
  /// 질문을 보내고 답변을 이벤트 스트림으로 받는다. [sessionId]가 null이면 새 대화.
  Stream<ChatEvent> sendMessage(String message, {int? sessionId});
  Future<List<ChatSession>> getSessions();
  Future<ChatSession> getSession(int id);
  Future<void> deleteSession(int id);
}
