import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  IO.Socket? _socket;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _initialized = false;

  Function(Map<String, dynamic>)? onMessageReceived;
  Function(Map<String, dynamic>)? onNotificationReceived;

  Future<void> connect() async {
    if (_initialized && _socket != null && _socket!.connected) return;

    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token == null) return;

    _socket = IO.io(
      AppConstants.baseUrl.replaceAll('/api', ''),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'authorization': 'Bearer $token'})
          .build(),
    );

    _socket!.on('connect', (_) {
      print('WebSocket connected');
      _initialized = true;
    });

    _socket!.on('disconnect', (_) {
      print('WebSocket disconnected');
      _initialized = false;
    });

    _socket!.on('message', (data) {
      print('Message received: $data');
      if (onMessageReceived != null) {
        onMessageReceived!(data as Map<String, dynamic>);
      }
    });

    _socket!.on('notification', (data) {
      print('Notification received: $data');
      if (onNotificationReceived != null) {
        onNotificationReceived!(data as Map<String, dynamic>);
      }
    });

    _socket!.connect();
  }

  void sendMessage({
    required String conversationId,
    required String message,
  }) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('sendMessage', {
      'conversationId': conversationId,
      'message': message,
    });
  }

  void joinConversation(String conversationId) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('joinConversation', {'conversationId': conversationId});
  }

  void leaveConversation(String conversationId) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('leaveConversation', {'conversationId': conversationId});
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _initialized = false;
  }
}
