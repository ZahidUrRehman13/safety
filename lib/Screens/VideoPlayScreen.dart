import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rabbit/Constants/ad_helper.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayScreen extends StatefulWidget {
  String videoUrl;
  VideoPlayScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  InterstitialAd? _interstitialAd;
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        _interstitialAd?.show();
        debugPrint("Ads_printed");
        return true;
      },
      child: Stack(
        children: [
          Positioned(
            child: VisibilityDetector(
              key: ObjectKey(flickManager),
              onVisibilityChanged: (visibility) {
                if (visibility.visibleFraction == 0 && mounted) {
                  flickManager.flickControlManager?.autoPause();
                } else if (visibility.visibleFraction == 1) {
                  flickManager.flickControlManager?.autoResume();
                }
              },
              child: FlickVideoPlayer(
                flickManager: flickManager,
                systemUIOverlayFullscreen: const [],
                flickVideoWithControls: const FlickVideoWithControls(
                  closedCaptionTextStyle: TextStyle(fontSize: 8),
                  controls: FlickPortraitControls(
                    fontSize: 25,
                    iconSize: 25,
                  ),
                ),
                flickVideoWithControlsFullscreen: const FlickVideoWithControls(
                  videoFit: BoxFit.contain,
                  controls: FlickLandscapeControls(),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
              child: Container(
            height: height * 0.078,
            width: double.infinity,
            color: Color(0xFFd9d9ff),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 16),
                  child: GestureDetector(
                      onTap: () {
                        _interstitialAd?.show();
                      },
                      child: Icon(Icons.arrow_back, color: Color(0xFF1e212d))),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pop(context);
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }
}
