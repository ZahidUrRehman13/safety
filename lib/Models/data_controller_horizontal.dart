import 'package:flutter/material.dart';
import 'data_model.dart';

class DataControllerHorizontal {
  final dataList = [
    DataModel(
        title: 'No Parking',
        subTitle: 'Parking is not allowed',
        image: 'assets/traffic/no-parking.png',
        actionText: 'View More',
        actionBgColor: const Color(0xFFd2dfff),
        display_text: 'This sign indicate that Parking of vehicle is prohibited in the relevant Area',
        route: 0,
        signImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/database-2bb1e.appspot.com/o/categories_icons%2Ftraffic%20sign%2Fcar-parking-icon.png?alt=media&token=8fa774a7-aa33-433f-b348-6b8755122c9b"),
    DataModel(
        title: 'Truck Is Prohibited',
        subTitle: 'Truck is not allowed',
        image: 'assets/traffic/no-trucks.png',
        actionText: 'More Items',
        actionBgColor: const Color(0xff5D808C),
        display_text: 'This sign indicate that that Heavy Truck is not allowed in this area',
        route: 0,
        signImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/edsmovie-25e8b.appspot.com/o/Screenshot_2.png?alt=media&token=59ae0e62-8bd9-4ff0-bb1a-0e74b492adcc"),
    DataModel(
        title: 'No Turn Right ',
        subTitle: 'Not Allowed turn right',
        image: 'assets/traffic/no-turn-right.png',
        actionText: 'Find Now',
        actionBgColor: const Color(0xff4C3063),
        display_text: 'Here in the specific location taking  turn to right is not allowed, in case of unfollow rules, police will fine',
        route: 0,
        signImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/edsmovie-25e8b.appspot.com/o/Screenshot_4.png?alt=media&token=e18a7d98-62d0-44ad-a020-2818c00ab020"),
    DataModel(
        title: 'Move Straight',
        subTitle: 'One Way Traffic ',
        image: 'assets/traffic/straight.png',
        actionText: 'View Practical',
        actionBgColor: const Color(0xff844595),
        display_text: 'Move Straight forward',
        route: 0,
        signImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/edsmovie-25e8b.appspot.com/o/Screenshot_5.png?alt=media&token=ea0b412a-5a65-4b17-8da5-005f0469e617"),
    DataModel(
        title: 'Stop Sign',
        subTitle: 'Stop your car ',
        image: 'assets/traffic/stop.png',
        actionText: 'Check More',
        actionBgColor: const Color(0xffBE6692),
        display_text: 'Here the specific sign give you order to   Stop your car',
        route: 0,
        signImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/edsmovie-25e8b.appspot.com/o/Screenshot_3.png?alt=media&token=54c4a869-a169-4cd9-836a-86d23962778c"),
    DataModel(
        title: 'Under Construction',
        subTitle: 'Road is under construction',
        image: 'assets/traffic/roadwork.png',
        actionText: 'View Now',
        actionBgColor: const Color(0xff35BCAF),
        display_text: 'This sign means that the road is under construction',
        route: 0,
        signImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/edsmovie-25e8b.appspot.com/o/Screenshot_3.png?alt=media&token=54c4a869-a169-4cd9-836a-86d23962778c"),
    DataModel(
        title: 'Zebra Cross',
        subTitle: 'Zebra Crossing for Pedal',
        actionText: 'View All',
        image: 'assets/traffic/pedestrian-crossing (1).png',
        actionBgColor: const Color(0xff9771BB),
        display_text:
            "This sign indicate that people can cross the road at the specific position, it warn you to look all around and then decide to move "
                "your car",
        route: 1,
        signImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/edsmovie-25e8b.appspot.com/o/Screenshot_3.png?alt=media&token=54c4a869-a169-4cd9-836a-86d23962778c"),
    DataModel(
        title: 'U turn Prohibited',
        subTitle: 'U turn Prohibited',
        image: 'assets/traffic/no-u-turn.png',
        actionText: 'Search All',
        actionBgColor: const Color(0xffB2615D),
        display_text: 'This sign indicate that stop is located Ahead',
        route: 0,
        signImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/edsmovie-25e8b.appspot.com/o/Screenshot_3.png?alt=media&token=54c4a869-a169-4cd9-836a-86d23962778c"),
  ];
}
