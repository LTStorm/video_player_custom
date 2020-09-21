import 'package:flutter/material.dart';
import 'video_player_custom.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CustomVideoPlayer player;
  ///Variable hold audio track
  List<dynamic> audioTracks;

  @override
  void initState() {
    audioTracks=List<dynamic>();
    ///Create Video Player
    player=CustomVideoPlayer.network("https://cdn.theoplayer.com/video/elephants-dream/playlist.m3u8",getTracksComplete: (audioTracks){
      ///Get audio tracks
      setState(() {
        this.audioTracks=audioTracks;
      });
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              ///Height constraint
                height: 300,
                child: player),
            Column(children:
            getWidgets()
              ,)
          ],
        ),
      ),
    );
  }
///Display list audio track
  List<Widget> getWidgets(){

    List<Widget> widgets = [];
    for(int i =0;i<this.audioTracks.length;i++) {
      widgets.add(ListTile(title : Text(this.audioTracks[i]),onTap: (){
        ///Play audiotrack when clicked
        player.setAudioTrack(this.audioTracks[i]);
      },));
    }
    return widgets;
  }
}

