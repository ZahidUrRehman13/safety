import 'package:banner_listtile/banner_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rabbit/Screens/PostScreens/PostBannerscreen.dart';
import 'package:rabbit/Screens/PostScreens/PostDataScreen.dart';
import 'package:rabbit/Widgets/VerticalMovieCard.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class PostDataOption extends StatefulWidget {
  const PostDataOption({super.key});

  @override
  State<PostDataOption> createState() => _PostDataOptionState();
}

class _PostDataOptionState extends State<PostDataOption> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.05, left: 8.0, right: 8.0, bottom: height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * 0.07,
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: const Color(0xFFDAA520),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PostBanner()));
                          },
                          child: Text("Text Or Image Banner")),
                    ),
                    Container(
                      height: height * 0.07,
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: const Color(0xFFDAA520),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PostDataScreen()));
                          },
                          child: Text("Video Or Image Base")),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('data').orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: 7,
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: height * 0.02),
                                    child: Container(
                                      height: height * 0.13,
                                      width: double.infinity,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black),
                                    ),
                                  ));
                            }),
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? const Center(
                            child: Text("No Upload History"),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: BannerListTile(
                                      backgroundColor: const Color(0xFFDAA520),
                                      borderRadius: BorderRadius.circular(8),
                                      bannerPosition: BannerPosition.topRight,
                                      imageContainer: snapshot.data!.docs[index]['thumb'] != ""
                                          ? Image(image: NetworkImage(snapshot.data!.docs[index]['thumb']), fit: BoxFit.cover)
                                          : Container(
                                              width: width * 0.15,
                                              height: height * 0.15,
                                              decoration: BoxDecoration(color: Colors.black12),
                                              child: Center(
                                                child: Text(snapshot.data!.docs[index]['text_value']),
                                              )),
                                      title: Text(
                                        snapshot.data!.docs[index]['title'],
                                        style: TextStyle(fontSize: 24, color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      subtitle: Text(snapshot.data!.docs[index]['description'], style: TextStyle(fontSize: 13, color: Colors.white)),
                                      trailing: IconButton(
                                          onPressed: () {
                                            if (snapshot.data!.docs[index]['video'] == "false") {
                                              if (snapshot.data!.docs[index]["thumb"] != "") {
                                                deleteImage(
                                                  snapshot.data!.docs[index]["thumb"],
                                                  snapshot.data!.docs[index].id,
                                                );
                                              } else {
                                                deleteDocumentImageOnly(snapshot.data!.docs[index].id);
                                              }
                                            } else {
                                              deleteVideo(
                                                snapshot.data!.docs[index]["sources"],
                                                snapshot.data!.docs[index]["thumb"],
                                                snapshot.data!.docs[index].id,
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                          )),
                                    ),
                                  );
                                }),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  callBackFunction() {}

  Future<void> deleteImage(String imagePath, documentId) async {
    try {
      String fileUrl = Uri.decodeFull(Path.basename(imagePath)).replaceAll(RegExp(r'(\?alt).*'), '');
      final Reference storageRef = FirebaseStorage.instance.ref().child(fileUrl);
      await storageRef.delete();
      deleteDocumentImageOnly(documentId);
      print('Image deleted successfully.');
    } catch (error) {
      print('Error deleting image: $error');
    }
  }

  Future<void> deleteVideo(
    String videoPath,
    String imagePath,
    documentId,
  ) async {
    try {
      String fileUrlImage = Uri.decodeFull(Path.basename(imagePath)).replaceAll(RegExp(r'(\?alt).*'), '');
      final Reference storageRefImage = FirebaseStorage.instance.ref().child(fileUrlImage);

      String fileUrlVideo = Uri.decodeFull(Path.basename(videoPath)).replaceAll(RegExp(r'(\?alt).*'), '');
      final Reference storageRefVideo = FirebaseStorage.instance.ref().child(fileUrlVideo);

      await storageRefImage.delete();
      await storageRefVideo.delete();

      deleteDocument(documentId);
    } catch (error) {
      print('Error deleting video: $error');
    }
  }

  Future<void> deleteDocument(String documentId) async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream = FirebaseFirestore.instance.collection('data').doc(documentId).snapshots();

    stream.listen((DocumentSnapshot<Map<String, dynamic>> snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        await FirebaseFirestore.instance
            .collection('categories_data')
            .doc("items")
            .collection(data["categoryId"])
            .doc(data['categoryDocId'])
            .delete();

        await FirebaseFirestore.instance.collection('data').doc(documentId).delete();
        setState(() {});
      } else {
        print('Document with ID $documentId does not exist.');
      }
    }, onError: (error) {
      print('Error retrieving document: $error');
    });
  }

  Future<void> deleteDocumentImageOnly(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('data').doc(documentId).delete();
      setState(() {});
    } catch (e) {}
  }
}
