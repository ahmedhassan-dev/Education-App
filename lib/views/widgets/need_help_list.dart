import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NeedHelpList extends StatefulWidget {
  const NeedHelpList({super.key});

  @override
  State<NeedHelpList> createState() => _NeedHelpListState();
}

class _NeedHelpListState extends State<NeedHelpList> {
  // YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=CyZsSlTyv5Y"),
  final List<YoutubePlayerController> _controllers = [
    'w-RMbt2FZnU',
    'CyZsSlTyv5Y',
  ]
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
          ),
        ),
      )
      .toList();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: YoutubePlayer(
                key: ObjectKey(_controllers[index]),
                controller: _controllers[index],
                actionsPadding: const EdgeInsets.only(left: 16.0),
                thumbnail: const SizedBox(
                  height: 10,
                )),
          );
        },
        itemCount: _controllers.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10.0),
      ),
    );
  }
}
