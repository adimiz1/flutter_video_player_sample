import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_flutter/video/cld_video_controller.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

late Cloudinary cloudinary;

void main() {
  cloudinary = CloudinaryObject.fromCloudName(cloudName: 'adimizrahi2');
  runApp(const VideoPlayerApp());
}

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late CldVideoController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    // _controller = CldVideoController(publicId: 'sea');
    _controller = CldVideoController(publicId: 'sea_turtle_arkyym', cloudinary: cloudinary);
    // _controller = CldVideoController.networkUrl(Uri.parse("https://res.cloudinary.com/jstickney/raw/upload/demo/minecraft/mat2.m3u8"));
    // final CldVideoController _controller = CldVideoController.networkUrl(Uri.parse('https://res.cloudinary.com/demo/video/upload/sp_auto/dog.m3u8'));
    // _controller = CldVideoController(publicId: 'sea', transformation: Transformation()..roundCorners(RoundCorners.max()), automaticStreamingProfile: false);
    // _controller = CldVideoController.networkUrl(Uri.parse('https://res.cloudinary.com/demo/video/upload/sp_auto:subtitles_(code_en-US;file_docs:narration.vtt)/sea_turtle.m3u8'));
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    // _controller2.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Video', textDirection: TextDirection.ltr,),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(
                _controller,
              ),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                // If the video is playing, pause it.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // If the video is paused, play it.
                  _controller.play();
                }
              });
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16), // Add some spacing between buttons
          FloatingActionButton(
            onPressed: () {
              _controller.dispose();
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
