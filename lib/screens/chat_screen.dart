import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/ui_constants.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: UiConstants.animationDurationMedium,
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(message: message));
      _messageController.clear();
      setState(() {
        _isComposing = false;
      });
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ChatBot'),
                  Text(
                    'Welcome, ${state.name}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                ],
              );
            }
            return const Text('ChatBot');
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(LogoutEvent());
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthenticatedState) {
            return Column(
              children: [
                Expanded(
                  child: BlocConsumer<ChatBloc, ChatState>(
                    listener: (context, state) {
                      if (state is ChatLoadedState) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                      }
                    },
                    builder: (context, state) {
                      final messages = state is ChatLoadedState ? state.messages : [];

                      if (messages.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 80,
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                              ),
                              const SizedBox(height: UiConstants.spaceM),
                              Text(
                                'No messages yet',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: UiConstants.spaceS),
                              Text(
                                'Send a message to start chatting!',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textLightColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: UiConstants.spaceM,
                          horizontal: UiConstants.spaceS,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          // Add current timestamp since it's not in the original model
                          final timestamp = DateTime.now().subtract(Duration(minutes: messages.length - index));

                          return MessageBubble(
                            message: message.text,
                            isUser: message.isUser,
                            timestamp: timestamp,
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildMessageComposer(),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.all(UiConstants.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(UiConstants.radiusL),
                border: Border.all(
                  color: AppColors.textLightColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: UiConstants.spaceM),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 12,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      style: AppTextStyles.bodyLarge,
                      minLines: 1,
                      maxLines: 5,
                      onChanged: (text) {
                        setState(() {
                          _isComposing = text.trim().isNotEmpty;
                        });
                      },
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _handleSendMessage();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: UiConstants.spaceM),
          CircleAvatar(
            radius: 24,
            backgroundColor: _isComposing
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: _isComposing ? _handleSendMessage : null,
            ),
          ),
        ],
      ),
    );
  }
}