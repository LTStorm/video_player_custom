library video_player_custom;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  String _url;
  VideoPlayerController _controller;
  VideoPlayer _player;
  Duration _forwardStep=Duration(seconds: 10);
  Duration _backwardStep=Duration(seconds: 10);

  CustomVideoPlayer.asset(String url){
    _controller=VideoPlayerController.asset(url);
    _player=VideoPlayer(_controller);
  }
  CustomVideoPlayer.network(String url){
    _controller=VideoPlayerController.network(url);
    _player=VideoPlayer(_controller);
  }

  CustomVideoPlayer.file(File file){
    _controller=VideoPlayerController.file(file);
    _player=VideoPlayer(_controller);
  }

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: widget._controller.value.aspectRatio,
        child: Stack(
          children: [
            widget._player,
            Column(
            children: [
              VideoProgressIndicator(widget._controller,allowScrubbing: true,),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    onPressed: (){
                      setState(() {
                        if (widget._controller.value.position<widget._backwardStep){
                          widget._controller.seekTo(Duration(seconds: 0));
                        }
                        else{
                          Duration skipTime=widget._controller.value.position-widget._backwardStep;
                          widget._controller.seekTo(skipTime);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(widget._controller.value.isPlaying?Icons.pause:Icons.play_arrow),
                    onPressed: (){
                      setState(() {
                        if (widget._controller.value.isPlaying){
                          widget._controller.pause();
                        }
                        else{
                          widget._controller.play();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    onPressed: (){
                      setState(() {
                        Duration skipTime=widget._controller.value.position+widget._forwardStep;
                        if(skipTime>widget._controller.value.duration){
                          widget._controller.seekTo(skipTime);
                        }
                        widget._controller.seekTo(skipTime);
                      });
                    },
                  ),
                ],
              )
            ],
            )

          ],
        ),
      ),
    );
  }
}

