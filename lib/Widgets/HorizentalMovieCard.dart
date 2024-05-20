import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:rabbit/Models/MovieModel.dart';
import 'package:rabbit/Screens/VideoPlayScreen.dart';
import 'package:badges/badges.dart' as badges;

class HorizontalMovieCard extends StatelessWidget {
  QueryDocumentSnapshot<Map<String, dynamic>>? movieModel;
  Function function;
  bool route;

  HorizontalMovieCard({super.key, this.movieModel, required this.route, required this.function});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        // function();
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        color: route ? Colors.white : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    route
                        ? SizedBox(
                            width: width * 0.5,
                            child: Text(
                              movieModel!["title"],
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 15.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ))
                        : Container(
                            width: width * 0.4,
                            height: height * 0.02,
                            color: Colors.black,
                          ),
                    route
                        ? SizedBox(
                            width: width * 0.5,
                            child: Text(
                              movieModel!["description"],
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ))
                        : Container(
                            width: width * 0.6,
                            height: height * 0.05,
                            color: Colors.black,
                          ),
                    Row(
                      children: [
                        route
                            ? Text(movieModel!["button_text"],
                                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20.0, color: const Color(0xFF004E00)))
                            : Container(
                                width: width * 0.4,
                                height: height * 0.05,
                                color: Colors.black,
                              ),
                        route
                            ? movieModel!["new"] == "true"
                                ? badges.Badge(
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
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              child: route
                  ? Container(
                      color: Color(int.parse(movieModel!["color"])),
                      height: height * 0.23,
                      width: width * 0.343,
                      child: Center(
                        child: movieModel!["text"] == "true"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(movieModel!["text_value"],
                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 26.0, color: Colors.white)),
                              )
                            : CachedNetworkImage(
                                imageUrl: movieModel!["thumb"],
                                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                    child: SizedBox(
                                        height: height * 0.15, width: width * 0.15, child: Image.asset("assets/images/loading_progress.gif"))),
                                errorWidget: (context, url, error) => const Center(child: Icon(Icons.sync)),
                                height: height * 0.23,
                                width: width * 0.343,
                                fit: BoxFit.cover,
                              ),
                      ),
                    )
                  : Container(
                      height: height * 0.2,
                      color: Colors.black,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
