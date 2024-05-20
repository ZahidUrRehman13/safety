import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rabbit/Screens/AllCategoriesItem.dart';

class GridViewItems extends StatelessWidget {
  const GridViewItems({
    super.key,
    required this.height,
    required this.width,
    required this.itemIcons,
    required this.itemNames,
    required this.itemId,
  });

  final double height;
  final double width;
  final String itemIcons;
  final String itemNames;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("itemId_fireStore= $itemId");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllCategoriesItem(
                      categoriesId: itemId,
                    )));
      },
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue)),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                  height: height * 0.07,
                  width: width * 0.13,
                  child: CachedNetworkImage(
                    imageUrl: itemIcons,
                    progressIndicatorBuilder: (context, url, downloadProgress) => const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.sync)),
                    width: double.infinity,
                    height: height * 0.07,
                  )),
              Text(itemNames, style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
            ],
          )),
    );
  }
}
