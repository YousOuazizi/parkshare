class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversationId'],
      senderId: json['senderId'],
      senderName: json['sender']?['firstName'] ?? json['senderName'] ?? '',
      senderAvatar: json['sender']?['avatarUrl'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
    );
  }
}

class ConversationModel {
  final String id;
  final String parkingId;
  final String parkingName;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final MessageModel? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;

  ConversationModel({
    required this.id,
    required this.parkingId,
    required this.parkingName,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      parkingId: json['parkingId'],
      parkingName: json['parking']?['name'] ?? '',
      otherUserId: json['otherUser']?['id'] ?? '',
      otherUserName: json['otherUser']?['firstName'] ?? '',
      otherUserAvatar: json['otherUser']?['avatarUrl'],
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
