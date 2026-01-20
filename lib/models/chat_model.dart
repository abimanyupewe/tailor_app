class ChatRoom {
  final String id;
  final String name;
  final String? avatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.name,
    this.avatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json, [String? myUserId]) {
    // Reliable ID extraction
    final id = json['id']?.toString() ?? '';

    // Backend provides dynamic partner info (Prioritize this)
    String name = json['partner_name'] ?? 'Unknown';
    String? avatar = json['partner_avatar'];

    // Fallback: If partner_name is missing/unknown, try nested "am I tailor?" logic
    if (name == 'Unknown' || name.isEmpty) {
      final tailor = json['tailor'];
      final customer = json['customer'];

      bool iAmTailor = false;

      if (myUserId != null && tailor != null && tailor['user'] != null) {
        final tailorUserId = tailor['user']['id']?.toString();
        if (tailorUserId == myUserId) {
          iAmTailor = true;
        }
      }

      if (iAmTailor) {
        // I am Tailor, show Customer
        if (customer != null) {
          name =
              customer['username'] ??
              customer['user']?['username'] ??
              'Customer';
          avatar = customer['avatar'] ?? customer['user']?['avatar'];
        }
      } else {
        // I am Customer, show Tailor
        if (tailor != null) {
          name =
              tailor['shop_name'] ??
              tailor['user']?['username'] ??
              'Tailor Shop';
          avatar = tailor['shop_image'] ?? tailor['user']?['avatar'];
        }
      }
    }

    return ChatRoom(
      id: id,
      name: name,
      avatar: avatar,
      lastMessage: (json['last_message'] is Map)
          ? (json['last_message']['text'] ?? '')
          : (json['last_message']?.toString() ?? ''),
      lastMessageTime:
          DateTime.tryParse(
            (json['last_message_time']?.toString() ?? '') == '' &&
                    (json['last_message'] is Map)
                ? (json['last_message']['created_at']?.toString() ?? '')
                : (json['last_message_time']?.toString() ??
                      json['created_at']?.toString() ??
                      ''),
          )?.toLocal() ??
          DateTime.now(),
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String myUserId) {
    // Robust sender ID extraction
    var sender = json['sender'];
    // Handle if sender is an object (nested)
    if (sender is Map) {
      sender = sender['id'];
    }

    final senderStr = sender?.toString() ?? json['sender_id']?.toString() ?? '';

    // DEBUG: Print comparison (Remove later)
    // print("MSG Debug: sender=$senderStr, myId=$myUserId, isMe=${senderStr == myUserId}");

    // Clean Text (Debug removed)
    final textContent = json['text'] ?? '';
    // final debugText = "$textContent [S:$senderStr | M:$myUserId]";

    return ChatMessage(
      id: json['id'].toString(),
      senderId: senderStr,
      text: textContent,
      timestamp:
          DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      // Prioritize backend 'is_me' logic, fallback to manual check
      isMe: json['is_me'] is bool ? json['is_me'] : (senderStr == myUserId),
    );
  }
}
