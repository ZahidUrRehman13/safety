import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class CacheImageView extends StatefulWidget {
  final String imageUrl;
  const CacheImageView({super.key, required this.imageUrl});

  @override
  State<CacheImageView> createState() => _CacheImageViewState();
}

class _CacheImageViewState extends State<CacheImageView> {
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
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.5,
                width: width,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  borderOnForeground: true,
                  shadowColor: Colors.grey.shade400,
                  child: PinchZoom(
                    resetDuration: const Duration(milliseconds: 100),
                    maxScale: 2.5,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      progressIndicatorBuilder: (context, url, downloadProgress) => const Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      width: width * 0.8,
                    ),
                  ),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.all(8.0), child: Text("This is Description FOR THE above Image, We are here for excited round next time...")),
              InkWell(
                onTap: () {
                  debugPrint("website button Press");
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: height * 0.3),
                    child: SizedBox(
                      height: height * 0.07,
                      width: width * 0.4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: const Color(0xFFDAA520),
                        elevation: 4.0,
                        child: Center(
                            child: Text(
                          "Visit Website",
                          style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w300),
                        )),
                      ),
                    ),
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
