import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../Widgets/VerticalMovieCard.dart';

class AllCategoriesItem extends StatefulWidget {
  String categoriesId;
  AllCategoriesItem({super.key, required this.categoriesId});

  @override
  State<AllCategoriesItem> createState() => _AllCategoriesItemState();
}

class _AllCategoriesItemState extends State<AllCategoriesItem> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFd2dfff), Color(0xFFced2ff),Color(0xFFcdcfff),Color(0xFFc3caff),],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('categories_data').doc("items").collection(widget.categoriesId).snapshots(),
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
                    ? Center(
                        child: Text(
                          "No Category  Found...",
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return VerticalMovieCard(
                            movieModel: snapshot.data!.docs[index],
                            route: true,
                            function: callBackFunction,
                          );
                        },
                      );
              },
            ),
          ),
        ));
  }

  callBackFunction() {}
}
