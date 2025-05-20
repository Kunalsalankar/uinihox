part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Message> messages;

  ChatLoadedState({required this.messages});
}

class ChatErrorState extends ChatState {
  final String message;

  ChatErrorState({required this.message});
}