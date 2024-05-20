import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rabbit/Constants/NotificationClass.dart';
import 'package:rabbit/Constants/ad_helper.dart';
import 'package:rabbit/Models/QuotesModel.dart';
import 'package:rabbit/Models/TryGymModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TryGym extends StatefulWidget {
  const TryGym({super.key});

  @override
  State<TryGym> createState() => _TryGymState();
}

class _TryGymState extends State<TryGym> {
  late TryGymModel gymModel;
  BannerAd? _bannerAd;

  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  void checkInternet() async {
    if (await AdHelper.checkInternetConnection()) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFd2dfff),
              Color(0xFFced2ff),
              Color(0xFFcdcfff),
              Color(0xFFc3caff),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder(
            future: getData(),
            // builder: (context, snapshot) {

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black12,
                        ),
                        height: height * 0.12,
                        width: width * 0.12,
                      );
                    },
                    itemCount: 8,
                  );
                } else if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _showStyledDialog(context, gymModel.exercises[index].gif);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: gymModel.exercises[index].gif,
                              progressIndicatorBuilder: (context, url, downloadProgress) => const Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                              height: height * 0.12,
                              width: width * 0.12,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: gymModel.exercises.length,
                  );
                }  else {
                  return Center(
                    child: Text(
                      "Internet Connection Failed",
                      style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black),
                    ),
                  );
                }
              },


            ),
      ),
    );
  }

  Future<TryGymModel?> getData() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json?fbclid=IwAR2gsu4SRvRRFkHK8JPTWHZXmaNP0dtpOG6h7ep4zQp7WaamX5S1UaSrc3A'); // Replace with your API URL
    final response = await http.get(url);
    final jsonData = json.decode(response.body);
    debugPrint("try_gym_response: $response");
    gymModel = TryGymModel.fromJson(jsonData);

    return gymModel;
  }

  void _showStyledDialog(BuildContext context, String imageUrl) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Adjust the border radius as needed
            ),
            elevation: 0, // No shadow
            backgroundColor: Colors.transparent, // Transparent background
            child: Container(
              height: height * 0.7,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                // image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * 0.5,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                          child: SizedBox(height: height * 0.15, width: width * 0.15, child: Image.asset("assets/images/loading_progress.gif"))),
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      height: height * 0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
