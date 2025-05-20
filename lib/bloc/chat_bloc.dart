import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Message> messages = [];

  ChatBloc() : super(ChatInitialState()) {
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  void _onSendMessageEvent(SendMessageEvent event, Emitter<ChatState> emit) async {
    final userMessage = Message(
      text: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);
    emit(ChatLoadedState(messages: List.from(messages)));

    await Future.delayed(const Duration(milliseconds: 500));

    final botResponse = _getBotResponse(event.message);
    final botMessage = Message(
      text: botResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );

    messages.add(botMessage);
    emit(ChatLoadedState(messages: List.from(messages)));
  }

  String _getBotResponse(String message) {
    message = message.toLowerCase();

    if (message.contains('hello') || message.contains('hi')) {
      return 'Hello there! How can I help you today?';
    } else if (message.contains('how are you')) {
      return 'I\'m just a bot, but I\'m functioning well. How about you?';
    } else if (message.contains('bye') || message.contains('goodbye')) {
      return 'Goodbye! Have a great day!';
    } else if (message.contains('name')) {
      return 'I\'m a ChatBot created for this Flutter application.';
    } else if (message.contains('thank')) {
      return 'You\'re welcome!';
    } else {
      return 'I\'m not sure how to respond to that. Can you ask me something else?';
    }
  }
}

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}