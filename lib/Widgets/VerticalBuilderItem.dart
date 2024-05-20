import 'package:flat_banners/flat_banners.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rabbit/Constants/ad_helper.dart';
import 'package:rabbit/Models/data_model.dart';
import 'package:rabbit/Screens/TryGym.dart';
import 'package:rabbit/Screens/WebViewScreen.dart';
import 'package:rabbit/Widgets/CacheImageView.dart';

class VerticalBuilderItem extends StatefulWidget {
  DataModel dataModel;
  bool routeVertical;
  int index;
  VerticalBuilderItem({super.key, required this.dataModel, required this.routeVertical, this.index = 0});

  @override
  State<VerticalBuilderItem> createState() => _VerticalBuilderItemState();
}

class _VerticalBuilderItemState extends State<VerticalBuilderItem> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.routeVertical ? const EdgeInsets.only(top: 8, bottom: 8) : const EdgeInsets.only(right: 8.0),
      child: FlatBanners(
        onPressed: () {
          if (widget.routeVertical) {
            if (widget.index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TryGym()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                            navUrl: widget.dataModel.display_text,
                            route: widget.dataModel.route,
                          )));
            }
          } else {
            _showStyledDialog(context, widget.dataModel.image!, widget.dataModel.display_text);
          }
        },
        subtitle: widget.dataModel.subTitle,
        title: widget.dataModel.title,
        btnText: widget.dataModel.actionText,
        image: widget.dataModel.image,
        imageWidth: 50,
        actionBtnBgColor: Colors.black12,
        gradientColors: [
          const Color(0xff5957AB).withOpacity(0.3),
          Colors.white,
        ],
      ),
    );
  }

  void _showStyledDialog(BuildContext context, String imageUrl, String text) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Adjust the border radius as needed
            ),
            elevation: 0, // No shadow
            backgroundColor: Colors.transparent, // Transparent background
            child: Container(
              height: height * 0.6,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                // image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)),
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(imageUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: width * 0.6,
                        child: _bannerAd == null
                            ? Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : AdWidget(ad: _bannerAd!),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
