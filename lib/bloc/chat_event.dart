part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent({required this.message});
}