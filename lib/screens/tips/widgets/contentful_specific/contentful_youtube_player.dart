import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentfulYoutube extends StatefulWidget {
  final EdgeInsets padding;
  final String url;

  const ContentfulYoutube({key, this.url, this.padding}) : super(key: key);
  @override
  _ContentfulYoutubeState createState() => _ContentfulYoutubeState(url);
}

class _ContentfulYoutubeState extends State<ContentfulYoutube> {
  final String url;

  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  final bool _isPlayerReady = false;

  _ContentfulYoutubeState(this.url);

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _playerState;
    _videoMetaData;
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(url);
    final _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        disableDragSeek: true,
        autoPlay: false,
        loop: false,
        mute: false,
      ),
    );

    return Container(
    
      margin: widget.padding,
      child: YoutubePlayer(
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration()
        ],
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Styleguide.color_accents_yellow_3,
        progressColors: ProgressBarColors(
          playedColor: Styleguide.color_accents_yellow_3,
          handleColor: Styleguide.color_accents_yellow_1,
        ),
        onReady: () {
          _controller.addListener(listener);
        },
      ),
    );
  }
}
