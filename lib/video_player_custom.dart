library video_player_custom;

import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

///Alias for callback function
typedef void VideoEndedCallback();
typedef void ErrorOccurCallback(String errorDescription);
typedef void VideoPlayerInitializedCallback();
typedef void IsBufferingCallback();
typedef void GetAudioTrackComplete(List<dynamic> audioTracks);

class CustomVideoPlayer extends StatefulWidget {
  ///Controller that control video player
  VideoPlayerController _controller;
  ///Player display video
  VideoPlayer _player;
  ///Callback for when video end
  VideoEndedCallback videoEnd;
  ///Callback for when error occur in video player
  ErrorOccurCallback errorOccur;
  ///Callback for when video player has done initialized
  VideoPlayerInitializedCallback playerInitialized;
  ///Callback for when video player is buffering video
  IsBufferingCallback isBuffering;
  ///Callback for getting audio tracks when video player has done initialized
  ///Use this callback to get audio track for your application
  GetAudioTrackComplete getTracksComplete;
  ///The duration step for skip forward
  ///Default is 10 seconds
  Duration _forwardStep = Duration(seconds: 10);
  ///The duration step for skip backward
  ///Default is 10 seconds
  Duration _backwardStep = Duration(seconds: 10);
  ///List hold audio tracks of video
  List<String> audioTracks = List<String>();
  ///Named constructor for playing video from asset
  CustomVideoPlayer.asset(String url,
      {this.errorOccur,
        this.isBuffering,
        this.playerInitialized,
        this.videoEnd,
        this.getTracksComplete}) {
    ///Create the controller instance
    _controller = VideoPlayerController.asset(url);
    init();
  }

  ///Named constructor for playing video from network url
  CustomVideoPlayer.network(String url,
      {this.errorOccur,
        this.isBuffering,
        this.playerInitialized,
        this.videoEnd,
        this.getTracksComplete}) {
    ///Create the controller instance
    _controller = VideoPlayerController.network(url);
    init();
  }

  ///Named constructor for playing video from file
  CustomVideoPlayer.file(File file,
      {this.errorOccur,
        this.isBuffering,
        this.playerInitialized,
        this.videoEnd,
        this.getTracksComplete}) {
    ///Create the controller instance
    _controller = VideoPlayerController.file(file);
    init();
  }

  ///Initialize the video player and controller
  void init() {
    ///Create the player instance and pass controller to player
    _player = VideoPlayer(_controller);
    ///Initialize the controller
    _controller.initialize().then((value) {
      ///Check if get track
      if(getTracksComplete!=null){
        _player.controller.getAudios().then(
                (value) {
              getTracksComplete(value);
            }
        );
      }
    });
    ///Add callback to controller
    _controller.addListener(() {
      ///Callback for when video end
      if (videoEnd != null) {
        if (_controller.value.position >= _controller.value.duration) {
          videoEnd();
        }
      }
      ///Callback for when error has occurred
      if (errorOccur != null) {
        if (_controller.value.hasError) {
          errorOccur(_controller.value.errorDescription);
        }
      }
      ///Callback for when player has done initialized
      if(playerInitialized!=null){
        if(_controller.value.initialized){
          playerInitialized();
        }
      }
      ///Callback for when player is buffering video
      if(isBuffering!=null){
        if(_controller.value.isBuffering){
          isBuffering();
        }
      }
    });
  }
  ///Starts playing the video
  void play(){
    _controller.play();
  }
  ///Pauses the video
  void pause(){
    _controller.pause();
  }
  ///Setter for forward step
  void setSkipForwardStep(Duration forwardStep){
    this._forwardStep=forwardStep;
  }
  ///Setter for backward step
  void setSkipBackwardStep(Duration backwardStep){
    this._backwardStep=backwardStep;
  }
  ///Getter for forward step
  Duration getForwardStep(){
    return _forwardStep;
  }
  ///Getter for backward step
  Duration getBackwardStep(){
    return _backwardStep;
  }
  ///Get duration of current playing video
  Duration getDurationOfVideo() {
    return _controller.value.duration;
  }
  ///Get current position of current playing video
  Duration getCurrentPosition() {
    return _controller.value.position;
  }
  ///Set current position of current playing video
  void seekTo(Duration position){
    _controller.seekTo(position);
  }
  ///Return if video is playing or not
  bool isPlaying() {
    return _controller.value.isPlaying;
  }
  ///Get volume of playing video
  ///0 is muted, 1 is maximum
  double getVolume() {
    return _controller.value.volume;
  }
  ///Set volume for video
  ///0 is muted, 1 is maximum
  void setVolume(double volumeValue) {
    ///Check volume value to ensure in range [0,1]
    if (volumeValue > 1) {
      volumeValue = 1;
    }
    if (volumeValue < 0) {
      volumeValue = 0;
    }
    ///Set volume for controller
    _controller.setVolume(volumeValue);
  }
  ///Sets whether or not the video should loop after playing once
  void setLooping(bool isLooping) {
    _controller.setLooping(isLooping);
  }
  ///Get list audio track of current playing video
  ///@return list of audio track, audio track will be in String type
  ///Only use this if you can ensure player has done initialized or else use
  ///get audio callback instead
  Future<List<dynamic>> getAudioTracks() {
    return _controller.getAudios();
  }
  ///Set which audio track will be played
  void setAudioTrack(String audioTrack) {
    _controller.setAudio(audioTrack);
  }

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();


}

///This widget will ocupy all free space of parent widget
class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  ///Variable to holds display control status
  var _isVisible = true;
  @override
  void initState() {
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      ///Expand video player to occupy all parent space
      constraints: BoxConstraints.expand(),
      child: Container(
        ///GestureDetector to display or hide control when tap on Screen
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          child: Stack(
            children: [
              widget._player,
              ///Widget to display or hide controll
              Visibility(
                visible: _isVisible,
                child: Container(
                  ///Decoration to make the button more visible
                  foregroundDecoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                  ///Column contain the progress bar and button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ///The progress bar
                      VideoProgressIndicator(
                        widget._controller,
                        ///Allow user to interact with the progress bar
                        ///Set to false to disable
                        allowScrubbing: true,
                      ),
                      Container(
                        ///Decoration to make the button more visible
                        decoration: BoxDecoration(
                          color: Colors.black26,
                        ),
                        ///Button row
                        child: Row(
                          ///Center the button
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ///Skip backward button
                            IconButton(
                              icon: Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  ///Check if current position is less than backward step
                                  ///If less than, sett current position to 0
                                  ///Else process skip backward
                                  if (widget._controller.value.position <
                                      widget._backwardStep) {
                                    widget._controller
                                        .seekTo(Duration(seconds: 0));
                                  } else {
                                    ///Calculate the current position after process
                                    Duration skipTime =
                                        widget._controller.value.position -
                                            widget._backwardStep;
                                    widget._controller.seekTo(skipTime);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                ///Change button depend on the playing state of player
                                widget._controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (widget._controller.value.isPlaying) {
                                    widget._controller.pause();
                                  } else {
                                    widget._controller.play();
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.skip_next,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  ///Check if current position is less than backward step
                                  ///If less than, sett current position to 0
                                  ///Else process skip forward
                                  ///
                                  /// Calculate the current position after process forward
                                  Duration skipTime =
                                      widget._controller.value.position +
                                          widget._forwardStep;
                                  if (skipTime >
                                      widget._controller.value.duration) {
                                    widget._controller.seekTo(skipTime);
                                  }
                                  widget._controller.seekTo(skipTime);
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
