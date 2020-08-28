import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:video_player_custom/video_player_custom.dart';

void main() {
  testWidgets("Simple widget", (WidgetTester tester) async{
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomVideoPlayer.network("http://www.sample-videos.com/video123/mp4/720/video123/mp4/720/big_buck_bunny_720p_30mb.mp4")),
        )
      );
  });
}
