// ignore_for_file: public_member_api_docs, sort_constructors_first
enum chatMessageType { user, bot }

class ChatModel {
  String? text;
  chatMessageType? type;
  ChatModel({required this.text, required this.type});
}
