import 'dart:async';

import 'package:chime_app/api_service.dart';
import 'package:chime_app/chat_screen.dart';
import 'package:chime_app/shared/widgets/buttons.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;

class ChatContents extends StatefulWidget {
  final String? promptTitle;
  const ChatContents({super.key, this.promptTitle});

  @override
  ChatContentsState createState() => ChatContentsState();
}

class ChatContentsState extends State<ChatContents> {
  final record = AudioRecorder();
  bool microphonePermission = false;
  bool isProcessingMessage = false;
  List<Widget> chatWidgets = [];
  List<Map<String, String>> messages = [];

  Future<void> _startRecording() async {
    if (await record.hasPermission()) {
      String audioPath = 'audio.wav';
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        audioPath = path.join(directory.path, 'audio.wav');
      }
      HapticFeedback.heavyImpact();
      await record.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: audioPath,
      );
      HapticFeedback.heavyImpact();
    }
  }

  Future<String> _stopAndProcessRecording() async {
    final recordedAudioPath = await record.stop();
    final XFile file = XFile(recordedAudioPath!);
    final ApiService apiService = ApiService();
    HapticFeedback.heavyImpact();
    return apiService.processAudio(file);
  }

  Future<void> recordUserMessage() async {
    if (isProcessingMessage) {
      return; // Prevent sending another message if one is already processing
    }

    setState(() => isProcessingMessage = true);

    Future<String> messageFuture;
    try {
      messageFuture = _stopAndProcessRecording();
    } catch (e) {
      setState(() {
        UserChatBubble(
          messageFuture: Future.value('Error processing message'),
        );
        isProcessingMessage = false;
      });
      return;
    }

    setState(() {
      chatWidgets.add(
        UserChatBubble(messageFuture: messageFuture),
      );
    });

    messageFuture.then((value) => {
          messages.add({"role": "user", "content": value}),
          getConversationPartnerResponse(),
          setState(() {
            isProcessingMessage = false;
          })
        });
  }

  void sendUserMessage(String message) async {
    setState(() {
      chatWidgets.add(UserChatBubble(
        messageFuture: Future.value(message),
      ));
      messages.add({"role": "user", "content": message});
      isProcessingMessage = false;
    });
    getConversationPartnerResponse();
  }

  Future<void> getConversationPartnerResponse() async {
    final ApiService apiService = ApiService();

    try {
      // make the response stream be able to be listened to by two different widgets
      final responseStream =
          apiService.generateConversationResponse(messages).asBroadcastStream();

      StreamController<String> streamController =
          StreamController<String>.broadcast();
      final List<String> messageChunks = [];

      responseStream.listen(
        (data) {
          messageChunks.add(data); // Accumulate data for other uses
          if (!streamController.isClosed) {
            streamController.add(
                messageChunks.join(" ")); // Add data to the streamController
          }
          HapticFeedback.selectionClick();
        },
        onDone: () {
          // Once done, close the streamController to signal completion.
          if (!streamController.isClosed) {
            streamController.close();
          }
          final message = messageChunks.join(' ');
          messages.add({"role": "assistant", "content": message});
          // Use the accumulated data as needed, e.g., for playing audio.
          AudioService().playAudioFromText(message);
          // Update UI state to reflect that processing is done.
          setState(() {
            isProcessingMessage = false;
          });
        },
        onError: (error) {
          // Handle stream error, if any.
          if (!streamController.isClosed) {
            streamController.addError(error);
            streamController.close();
          }
          setState(() {
            isProcessingMessage = false;
          });
        },
      );

      // Immediately add the BotChatBubble widget to use the streamController's stream.
      setState(() {
        chatWidgets.add(BotChatBubble(messageStream: streamController.stream));
      });
    } catch (e) {
      setState(() {
        chatWidgets.add(
          BotChatBubble(
            messageStream: Stream.value('Error processing message'),
          ),
        );
        isProcessingMessage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
    if (widget.promptTitle != null) {
      sendUserMessage(widget.promptTitle!);
    }
  }

  Future<void> _checkMicrophonePermission() async {
    if (await record.hasPermission()) {
      setState(() {
        microphonePermission = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var permissionButton = Container(
        padding: const EdgeInsets.all(12.0),
        child: Button(
          text: "  Enable Microphone  ",
          onPressed: _checkMicrophonePermission,
        ));

    var recordButton = BottomBar(
      onStartRecording: _startRecording,
      onStopRecording: recordUserMessage,
      disabled: isProcessingMessage,
    );

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: chatWidgets.length,
              itemBuilder: (BuildContext context, int index) {
                return chatWidgets[index];
              },
            ),
          ),
        ),
        // Permission button is shown if the app does not have permission to record audio
        // Record button is shown if the app has permission to record audio
        SafeArea(child: microphonePermission ? recordButton : permissionButton),
      ],
    );
  }
}

class AudioService {
  // singleton
  AudioService._internal();
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  // final _audioPlayer = AudioPlayer();

  Future<void> playAudioFromText(String text) async {
    final ApiService apiService = ApiService();
    await apiService.speakText(text);
    // final audioBytes = await apiService.generateSpeech(text);
    // await _audioPlayer.setAudioSource(FromBytesSource(audioBytes));
    // _audioPlayer.play();
  }
}

// Feed your own stream of bytes into the player - Taken from JustAudio package
class FromBytesSource extends StreamAudioSource {
  final List<int> bytes;
  FromBytesSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
