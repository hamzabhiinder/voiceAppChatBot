import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_application/api_Services/api_services.dart';
import 'package:voice_application/text_to_speech/chat_model.dart';

class ReplyToTextScreen extends StatefulWidget {
  const ReplyToTextScreen({super.key});

  @override
  State<ReplyToTextScreen> createState() => _ReplyToTextScreenState();
}

class _ReplyToTextScreenState extends State<ReplyToTextScreen> {
  SpeechToText speechToText = SpeechToText();
  String text = "Hold the button and start speaking";
  bool isListining = false;
  var scrollController = ScrollController();

  scrollMethod() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(microseconds: 300),
      curve: Curves.easeOut,
    );
  }

  final List<ChatModel> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 85.0,
        animate: isListining,
        duration: const Duration(seconds: 2),
        glowColor: Colors.blue,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapUp: (detail) async {
            setState(() {
              isListining = false;
            });
            speechToText.stop();
            messages.add(ChatModel(text: text, type: chatMessageType.user));
            var msg = await ApiService.sendMessage(text);
            setState(() {
              messages.add(ChatModel(text: msg, type: chatMessageType.bot));
            });
          },
          onTapDown: (details) async {
            if (!isListining) {
              log("isListining: $isListining");

              var availible = await speechToText.initialize();
              log("availble: $availible");
              if (availible) {
                setState(() {
                  isListining = true;
                  speechToText.listen(
                    onResult: (result) {
                      setState(() {
                        text = result.recognizedWords;
                      });
                    },
                  );
                });
              }
            }
          },
          child: CircleAvatar(
            radius: 35,
            child: Icon(isListining ? Icons.mic : Icons.mic_none),
          ),
        ),
      ),
      appBar: AppBar(
        leading: const Icon(
          Icons.sort_rounded,
          color: Colors.white,
        ),
        title: const Text(
          "Speech to Text",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                // alignment: Alignment.bottomCenter,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black45,
                ),
                child: ListView.builder(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: messages.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var chat = messages[index];
                    log("From Message ${messages[index].text}");
                    return chatBubble(chattext: chat.text, type: chat.type);
                  },
                ),
              ),
            ),
            const Text(
              "Developed by Popa Production",
              style: TextStyle(color: Colors.black45, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBubble({required chattext, required chatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          child: Icon(
            Icons.person_rounded,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8, top: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Text(
              chattext,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
