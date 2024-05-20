import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rabbit/Constants/ad_helper.dart';
import 'package:rabbit/Widgets/HorizentalMovieCard.dart';
import 'package:rabbit/Widgets/VerticalMovieCard.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('data').orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: VerticalMovieCard(
                          route: false,
                          function: callBackFunction,
                        ),
                      );
                    });
              }
              return snapshot.data!.docs.isEmpty
                  ? const Center(
                      child: Text("No Data..."),
                    )
                  : ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data!.docs[index]['aligment'] == "vertical") {
                              return VerticalMovieCard(
                                movieModel: snapshot.data!.docs[index],
                                route: true,
                                function: callBackFunction,
                              );
                            } else {
                              return HorizontalMovieCard(
                                movieModel: snapshot.data!.docs[index],
                                route: true,
                                function: callBackFunction,
                              );
                            }
                          },
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  callBackFunction() {
    // showPopUp();
  }

  // showPopUp() {
  //   double height = MediaQuery.of(context).size.height;
  //   PopupBanner(
  //     context: context,
  //     height: height * 0.5,
  //     images: [
  //       "https://firebasestorage.googleapis.com/v0/b/edsmovie-25e8b.appspot.com/o/congrats-7.gif?alt=media&token=c74595f8-4801-44a7-a660-ea8c60da11c2",
  //     ],
  //     dotsAlignment: Alignment.bottomCenter,
  //     dotsColorActive: const Color(0xFFDAA520),
  //     dotsColorInactive: Colors.grey.withOpacity(0.5),
  //     onClick: (index) {
  //       debugPrint("CLICKED $index");
  //     },
  //   ).show();
  // }
}
