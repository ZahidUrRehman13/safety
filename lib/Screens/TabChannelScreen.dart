import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rabbit/Models/QuotesModel.dart';
import 'package:rabbit/Models/data_controller_horizontal.dart';
import 'package:rabbit/Screens/PostScreens/PostDataOption.dart';
import 'package:rabbit/Widgets/VerticalBuilderItem.dart';
import 'package:shimmer/shimmer.dart';
import '../Models/data_controller_vertical.dart';
import 'package:http/http.dart' as http;

class TabChannelScreen extends StatefulWidget {
  const TabChannelScreen({super.key});

  @override
  State<TabChannelScreen> createState() => _TabChannelScreenState();
}

class _TabChannelScreenState extends State<TabChannelScreen> {
  QuotesModel? quotesModel;
  String value = "user";

  @override
  Widget build(BuildContext context) {
    final dataVertical = DataControllerVertical();
    final dataHorizontal = DataControllerHorizontal();
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder(
                future: getQuotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: buildColumn(dataVertical, true, dataHorizontal),
                    );
                  }
                  return buildColumn(dataVertical, false, dataHorizontal);
                }),
          ),
        ),
      ),
    );
  }

  Future getQuotes() async {
    final url = Uri.parse('http://api.quotable.io/random');
    final response = await http.get(url);
    final jsonData = json.decode(response.body);
    quotesModel = QuotesModel.fromJson(jsonData);
  }

  Widget buildColumn(DataControllerVertical dataVertical, bool shimmer, DataControllerHorizontal dataControllerHorizontal) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        shimmer
            ? Container(
                height: height * 0.03,
                width: width * 0.35,
                color: Colors.black,
              )
            : value == "admin"
                ? InkWell(
                    onTap: () {
                      // getAllTokens();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostDataOption()));
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Upload Data',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            ),
                            radius: 15,
                          ),
                        )
                      ],
                    ),
                  )
                : const Text(
                    'Traffic Sign',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 105,
          child: ListView.builder(
            itemCount: dataControllerHorizontal.dataList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return VerticalBuilderItem(
                dataModel: dataControllerHorizontal.dataList[index],
                routeVertical: false,
              );
            },
          ),
        ),
        const SizedBox(height: 10.0),
        shimmer
            ? Container(
                height: height * 0.03,
                width: width * 0.35,
                color: Colors.black,
              )
            : const Text(
                'Read Safety Manuals',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
        const SizedBox(height: 10.0),
        ListView.builder(
          itemCount: dataVertical.dataList.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return VerticalBuilderItem(
              dataModel: dataVertical.dataList[index],
              routeVertical: true,
              index: index,
            );
          },
        )
      ],
    );
  }
}
