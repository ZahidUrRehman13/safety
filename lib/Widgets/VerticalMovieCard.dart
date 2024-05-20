import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:rabbit/Models/MovieModel.dart';
import 'package:rabbit/Screens/VideoPlayScreen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:rabbit/Screens/WebViewScreen.dart';

class VerticalMovieCard extends StatelessWidget {
  QueryDocumentSnapshot<Map<String, dynamic>>? movieModel;
  Function function;
  bool route;

  VerticalMovieCard({super.key, this.movieModel, required this.route, required this.function});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (movieModel!["video"] == "true") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayScreen(
                        videoUrl: movieModel!["sources"],
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                        route: 0,
                        navUrl: movieModel!["sources"],
                      )));
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        color: route ? Color(0xFF1e212d) : Colors.transparent,
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                    child: route
                        ? Stack(
                            children: [
                              Positioned(
                                child: CachedNetworkImage(
                                  imageUrl: movieModel!["thumb"],
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                      child: SizedBox(
                                          height: height * 0.15, width: width * 0.15, child: Image.asset("assets/images/loading_progress.gif"))),
                                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.sync)),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              movieModel!["video"] == "true"
                                  ? Positioned(
                                      left: width * 0.4,
                                      right: width * 0.4,
                                      top: height * 0.1,
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: const Color(0xFFc3caff),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: const Color(0xFFDAA520),
                                          size: height * width * 0.00015,
                                        ),
                                      ))
                                  : Container(
                                      color: Colors.transparent,
                                    ),
                            ],
                          )
                        : Container(
                            height: 200,
                            color: Colors.black,
                          ),
                  ),
                ),
                Positioned(
                  left: width * 0.9,
                  top: height * 0.005,
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.05,
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/eagle_transparent.png"), fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: height * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    route
                        ? Row(
                            children: [
                              Text(movieModel!["title"], style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 15.0,color: Colors.white)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: badges.Badge(
                                  badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
                                  badgeContent: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                  badgeStyle: badges.BadgeStyle(
                                    shape: badges.BadgeShape.twitter,
                                    badgeColor: const Color(0xFFDAA520),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: width * 0.4,
                            height: height * 0.02,
                            color: Colors.black,
                          ),
                    route
                        ? Text(movieModel!["description"], style: GoogleFonts.montserrat(fontWeight: FontWeight.w400, fontSize: 14.0,color: Colors
                        .white),)
                        : Container(
                            width: width * 0.7,
                            height: height * 0.05,
                            color: Colors.white,
                          ),
                    Row(
                      children: [
                        route
                            ? Text(movieModel!["button_text"],
                                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20.0, color:  Colors.green))
                            : Container(
                                width: width * 0.4,
                                height: height * 0.05,
                                color: Colors.white,
                              ),
                        route
                            ? movieModel!["new"] == "true"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: badges.Badge(
                                      badgeStyle: badges.BadgeStyle(
                                        shape: badges.BadgeShape.square,
                                        borderRadius: BorderRadius.circular(5),
                                        padding: const EdgeInsets.all(2),
                                        badgeGradient: const badges.BadgeGradient.linear(
                                          colors: [
                                            Colors.purple,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      position: badges.BadgePosition.topEnd(top: -12, end: -20),
                                      badgeContent: const Text(
                                        'NEW',
                                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(
                                width: width * 0.2,
                                height: height * 0.05,
                                color: Colors.black,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
