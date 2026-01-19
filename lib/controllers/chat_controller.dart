import 'dart:async';
import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:tailor_app/models/chat_model.dart';

class ChatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final chatRooms = <ChatRoom>[].obs;
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  Timer? _pollingTimer;
  String? _currentRoomId;

  // For storing current user ID
  String? myUserId;

  int get totalUnreadCount =>
      chatRooms.fold(0, (sum, room) => sum + room.unreadCount);

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchMyUserId();
    // Fetch rooms after we know who we are (though now less critical for parsing, still good for logic)
    fetchChatRooms();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchMyUserId() async {
    try {
      print("ChatController: Fetching user profile...");
      final response = await _apiService.getProfile();
      print("ChatController: Profile response: $response");

      if (response != null) {
        myUserId = response['id']?.toString() ?? response['pk']?.toString();
        print("ChatController: myUserId set to $myUserId");

        // Force refresh all messages/rooms with new ID if valid
        if (myUserId != null) {
          chatRooms.refresh();
          messages.refresh();
        }
      } else {
        print("ChatController: Profile response is null");
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> fetchChatRooms({bool background = false}) async {
    try {
      if (!background) isLoading.value = true;
      final response = await _apiService.getChatRooms();
      // Assuming response is a list or contains a list 'results'
      List<dynamic> data;
      if (response is Map && response.containsKey('results')) {
        data = response['results'];
      } else if (response is List) {
        data = response;
      } else {
        data = [];
      }

      final List<ChatRoom> parsedRooms = [];
      for (var item in data) {
        try {
          parsedRooms.add(ChatRoom.fromJson(item, myUserId));
        } catch (e) {
          print("Error parsing chat room ID ${item['id']}: $e");
        }
      }

      chatRooms.assignAll(parsedRooms);
    } catch (e) {
      print('Error fetching chat rooms: $e');
    } finally {
      if (!background) isLoading.value = false;
    }
  }

  Future<void> openChat(String roomId) async {
    _currentRoomId = roomId;
    messages.clear();
    await fetchMessages(roomId);

    // Start polling for new messages (simple implementation)
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentRoomId == roomId) {
        fetchMessages(roomId, background: true);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> fetchMessages(String roomId, {bool background = false}) async {
    try {
      if (!background) isLoading.value = true;

      if (myUserId == null) await fetchMyUserId();

      final response = await _apiService.getChatMessages(roomId);
      List<dynamic> data;
      if (response is Map && response.containsKey('results')) {
        data = response['results'];
      } else if (response is List) {
        data = response;
      } else {
        data = [];
      }

      // We might want to merge or just replace. Replacing is easier for MVP.
      // But for better UX we should check for IDs.
      final newMessages = data
          .map((e) => ChatMessage.fromJson(e, myUserId ?? ''))
          .toList();

      // Reverse if backend sends newest first, but typical chat UI needs oldest top (or newest bottom).
      // Let's assume backend sends chronological or we sort.
      // Usually backend sends newest first for pagination, or oldest first.
      // Let's sort by timestamp just in case.
      newMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      if (background) {
        // If content is different, update.
        // A simple check: if length different or last message different.
        if (newMessages.length != messages.length ||
            (messages.isNotEmpty && newMessages.last.id != messages.last.id)) {
          messages.assignAll(newMessages);
        }
      } else {
        messages.assignAll(newMessages);
      }
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      if (!background) isLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    if (_currentRoomId == null ||
        _currentRoomId!.isEmpty ||
        text.trim().isEmpty) {
      if (_currentRoomId == null || _currentRoomId!.isEmpty) {
        Get.snackbar('Error', 'Cannot send: Room ID is missing.');
      }
      return;
    }

    try {
      isSending.value = true;
      final response = await _apiService.sendMessage(_currentRoomId!, text);

      // Optimistic update or wait for refresh
      // 1. Refresh messages in current room
      await fetchMessages(_currentRoomId!, background: true);
      // 2. Refresh the chat list (inbox) to show latest message snippet
      fetchChatRooms(background: true);
    } catch (e) {
      print('ChatController: Error sending message: $e');
      if (e.toString().contains('404')) {
        Get.snackbar('Error', 'Chat room not found (404). ID: $_currentRoomId');
      } else {
        Get.snackbar('Error', 'Failed to send message: ${e.toString()}');
      }
    } finally {
      isSending.value = false;
    }
  }

  Future<void> leaveChat() async {
    _currentRoomId = null;
    _pollingTimer?.cancel();
  }

  Future<void> startChatWithTailor(String tailorId) async {
    print('ChatController: Attempting to start chat with ID: $tailorId');
    if (tailorId.isEmpty) {
      Get.snackbar('Error', 'Invalid Tailor ID (empty)');
      return;
    }
    try {
      isLoading.value = true;
      print('ChatController: Calling ApiService.startChat...');
      final response = await _apiService.startChat(tailorId);
      print('ChatController: ApiService returned: $response');

      // Expecting response to contain room info, minimally the ID
      if (response != null) {
        // Try multiple keys for ID
        var roomId =
            response['id']?.toString() ??
            response['room_id']?.toString() ??
            response['pk']?.toString() ??
            response['uuid']?.toString();

        print(
          "ChatController: Extracted Room ID: $roomId from response keys: ${response.keys}",
        );

        if (roomId == null || roomId.isEmpty || roomId == 'null') {
          Get.snackbar(
            'Error',
            'Invalid Room ID from backend. Keys found: ${response.keys}',
          );
          return;
        }

        // Go to chat detail
        // Fetch rooms in background so we don't block navigation
        fetchChatRooms(background: true);

        print(
          "ChatController: Navigating to /chat/detail with args: roomId=$roomId",
        );
        Get.toNamed(
          '/chat/detail',
          arguments: {
            'roomId': roomId,
            'name':
                response['partner_name'] ??
                response['participant_name'] ??
                'Chat',
            'avatar':
                response['partner_avatar'] ?? response['participant_avatar'],
          },
        );
      } else {
        print("ChatController: Response is null");
        Get.snackbar('Error', 'Failed to start chat: Null response');
      }
    } catch (e) {
      print('Error starting chat: $e');
      Get.snackbar('Error', 'Could not start chat: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
