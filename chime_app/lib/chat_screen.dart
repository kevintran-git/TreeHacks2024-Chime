// ignore_for_file: must_be_immutable

import 'package:chime_app/api_service.dart';
import 'package:flutter/material.dart';
import 'package:chime_app/settings.dart';
import 'package:chime_app/chatcontents.dart';
import 'package:flutter/gestures.dart';

// A stateless widget that represents the chat UI
class ChatUI extends StatelessWidget {
  // A constructor that takes an optional key parameter
  final String? promptTitle;
  const ChatUI({super.key, this.promptTitle});

  // A method that builds the chat UI widget
  @override
  Widget build(BuildContext context) {
    // Return a scaffold widget that contains the chat window and the background color
    return Scaffold(
      appBar: AppBar(
        title: null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context); // Updated to navigate back a page
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: ChatWindow(
        ChatContents(promptTitle: promptTitle),
      ),
    );
  }
}

// A stateless widget that represents a user chat bubble
class BotChatBubble extends StatelessWidget {
  // A final string that holds the message text
  final Stream<String> messageStream;
  String message = "";

  // A constructor that takes a required message parameter, a required callback function, and an optional key parameter
  BotChatBubble({required this.messageStream, super.key});

  // A method that builds the user chat bubble widget
  @override
  Widget build(BuildContext context) {
    final message = StreamBuilder<String>(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          this.message = snapshot.data ?? '';
          return Text(this.message,
              style: Theme.of(context).textTheme.displaySmall);
        } else {
          // Handle loading state or no data state
          return const LinearProgressIndicator();
        }
      },
    );
    // Return an align widget that aligns the chat bubble to the left
    return Align(
      alignment: Alignment.centerLeft,
      // Add a row widget that contains the user avatar and the message container
      child: Row(
        children: [
          // A flexible widget that adapts to the available space with a container widget
          Flexible(
            child: Container(
              width: 320,
              // Add vertical margin of 8 pixels
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              // Add vertical padding of 8 pixels and horizontal padding of 16 pixels
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 16.0,
                bottom: 16.0,
                right: 4.0,
              ),
              // Add a decoration widget that sets the background color and the border radius
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              // Add an intrinsic width widget that adjusts the width to the content
              child: IntrinsicWidth(
                // Add a row widget that contains the message text and the edit button
                child: Row(
                  children: [
                    // An expanded widget that fills the available space with a text widget
                    Expanded(child: message),
                    // A constant sized box widget that adds horizontal spacing of 8 pixels
                    const SizedBox(width: 8.0), // Add spacing here
                    // An icon button widget that shows the edit icon and performs the edit logic
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () {
                        // play audio
                        AudioService().playAudioFromText(this.message);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserChatBubble extends StatefulWidget {
  final Future<String> messageFuture;
  late String message;
  late List<Map<String, dynamic>>? annotations;

  UserChatBubble({
    required this.messageFuture,
    this.annotations,
    super.key,
  });

  @override
  State<UserChatBubble> createState() => _UserChatBubbleState();
}

class _UserChatBubbleState extends State<UserChatBubble> {
  @override
  void initState() {
    super.initState();
    _prepareAnnotations();
  }

  Future<void> _prepareAnnotations() async {
    // Fetch the annotations from the server
    // Use the 'message' directly
    final message = await widget.messageFuture;
    setState(() {
      widget.message = message;
    });

    final annotations =
        await ApiService().generateAnnotationResponse(widget.message);
    
    setState(() {
      widget.annotations = annotations;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return an align widget that aligns the chat bubble to the left
    final userText = FutureBuilder<String>(
      future: widget.messageFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        } else {
          return Text(snapshot.data ?? '',
              style: Theme.of(context).textTheme.bodySmall);
        }
      },
    );

    final loadingOrAnnotation = widget.annotations == null
        ? userText
        : _prepareAnnotatedMessage(context, widget.message);

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              width: 320,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: loadingOrAnnotation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _prepareAnnotatedMessage(BuildContext context, String text) {
    if (widget.annotations == null || widget.annotations!.isEmpty) {
      return Text(text, style: Theme.of(context).textTheme.bodySmall);
    }

    // Build a list of TextSpans with annotated snippets
    List<TextSpan> spans = [];
    String remainingText = text;

    for (var annotation in widget.annotations!) {
      int startIndex = remainingText.indexOf(annotation['snippet']);
      if (startIndex != -1) {
        String textBeforeSnippet = remainingText.substring(0, startIndex);
        if (textBeforeSnippet.isNotEmpty) {
          spans.add(TextSpan(text: textBeforeSnippet));
        }

        spans.add(TextSpan(
          text: annotation['snippet'],
          style: const TextStyle(
              decoration: TextDecoration.underline, color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // The dialog's content
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Comment: ${annotation['comment']}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                        const SizedBox(height: 10),
                        Text('Example: ${annotation['example']}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('x'),
                      ),
                    ],
                  );
                },
              );
            },
        ));
        dynamic index = startIndex + annotation['snippet'].length;
        remainingText = remainingText.substring(index);
      }
    }

    // Add any remaining text after the last snippet
    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(text: remainingText));
    }

    return RichText(
        text: TextSpan(
            children: spans, style: Theme.of(context).textTheme.bodySmall));
  }
}

class BottomBar extends StatefulWidget {
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final bool disabled;

  const BottomBar({
    Key? key,
    required this.onStartRecording,
    required this.onStopRecording,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  Color? backgroundColor; // Declare without initial value
  Color? pressedBackgroundColor;

  void _onPress() {
    if (!widget.disabled) {
      widget.onStartRecording();
      setState(() => backgroundColor = pressedBackgroundColor);
    }
  }

  void _onRelease() {
    if (!widget.disabled) {
      widget.onStopRecording();
      // Reset to null to use the theme color from the build context
      setState(() => backgroundColor = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use local variable to decide the color
    Color bg = backgroundColor ?? Theme.of(context).primaryColor;
    pressedBackgroundColor = bg.withOpacity(.6);

    // Change the appearance when it is disabled
    if (widget.disabled) {
      bg = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onLongPress: _onPress,
        onLongPressUp: _onRelease,
        child: CircleAvatar(
          backgroundColor: bg, // Use the determined background color
          radius: 40,
          child: const Icon(
            Icons.mic,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// A stateless widget that represents the chat window
class ChatWindow extends StatelessWidget {
  // A final widget that holds the child widget
  final Widget child;

  // A constructor that takes a required child parameter and an optional key parameter
  const ChatWindow(this.child, {super.key});

  // A method that builds the chat window widget
  @override
  Widget build(BuildContext context) {
    // Return a layout builder widget that adapts to the screen size
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // If the maximum width is less than 500 pixels, return a container widget that sets the background color
        if (constraints.maxWidth < 500) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: child,
          );
        } else {
          // Otherwise, return a padding widget that adds padding and contains a container widget
          return Padding(
            padding: const EdgeInsets.fromLTRB(56, 10, 56, 24),
            child: Container(
              // Add a decoration widget that sets the background color and the border radius
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(35),
              ),
              child: child,
            ),
          );
        }
      },
    );
  }
}
