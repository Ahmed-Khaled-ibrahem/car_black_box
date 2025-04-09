import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({this.videoUrl, Key? key}) : super(key: key);

  String? videoUrl;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool isPlaying = false; // Control stream state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View")),
      body: Column(
        children: [
          Expanded(
            child: isPlaying
                ? InteractiveViewer(
                  child: Mjpeg(
                                stream: widget.videoUrl ?? "",
                                isLive: true,
                                fit: BoxFit.contain,
                                error: (e, w, q) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 50, color: Colors.red),
                        Text("Error loading video"),
                      ],
                    ),
                  );
                                },
                              ),
                )
                : const Center(child: Text("Stream is Stopped", style: TextStyle(fontSize: 20))),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying; // Toggle play/stop
                });
              },
              child: Text(isPlaying ? "Stop Stream" : "Start Stream"),
            ),
          ),
        ],
      ),
    );
  }
}