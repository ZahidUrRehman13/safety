import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_grid_view/group_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Widgets/GridViewItems.dart';

class TabCategoryScreen extends StatefulWidget {
  const TabCategoryScreen({super.key});

  @override
  State<TabCategoryScreen> createState() => _TabCategoryScreenState();
}

class _TabCategoryScreenState extends State<TabCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      height: height,
      width: width,
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
            stream: FirebaseFirestore.instance.collection('categories').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildGroupGridView(snapshot, height, width, false);
              }
              return buildGroupGridView(snapshot, height, width, true);
            }),
      ),
    ));
  }

  GroupGridView buildGroupGridView(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, double height, double width, bool route) {
    return GroupGridView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16),
        sectionCount: route ? snapshot.data!.docs.length : 3,
        headerForSection: (section) => Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(route ? snapshot.data!.docs[section].id : '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        itemInSectionBuilder: (_, indexPath) {
          final itemNames = route ? snapshot.data!.docs[indexPath.section]['items'][indexPath.index] : '';
          final itemIcons = route ? snapshot.data!.docs[indexPath.section]['icons'][indexPath.index] : '';
          final itemId = route ? snapshot.data!.docs[indexPath.section]['id'][indexPath.index] : '';
          return route
              ? GridViewItems(
                  height: height,
                  width: width,
                  itemIcons: route ? itemIcons : Container(),
                  itemNames: itemNames,
                  itemId: itemId,
                )
              : Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: GridViewItems(
                    height: height,
                    width: width,
                    itemIcons: itemIcons,
                    itemNames: itemNames,
                    itemId: itemId,
                  ));
        },
        itemInSectionCount: (section) => route ? snapshot.data!.docs[section]['items'].length : 5);
  }
}
