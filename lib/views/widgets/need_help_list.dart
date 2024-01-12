import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NeedHelpList extends StatefulWidget {
  final List<String> solutions;
  const NeedHelpList({super.key, required this.solutions});

  @override
  State<NeedHelpList> createState() => _NeedHelpListState();
}

class _NeedHelpListState extends State<NeedHelpList> {
  // YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=CyZsSlTyv5Y"),

  @override
  Widget build(BuildContext context) {
    final List<YoutubePlayerController> controllers = widget.solutions
        .map<YoutubePlayerController>(
          (videoId) => YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
            ),
          ),
        )
        .toList();
    return SizedBox(
      height: 370,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: YoutubePlayer(
                key: ObjectKey(controllers[index]),
                controller: controllers[index],
                actionsPadding: const EdgeInsets.only(left: 16.0),
                thumbnail: const SizedBox(
                  height: 10,
                )),
          );
        },
        itemCount: controllers.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10.0),
      ),
    );
  }
}
