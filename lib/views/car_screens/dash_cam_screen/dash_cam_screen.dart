import 'package:car_black_box/views/car_screens/dash_cam_screen/video_list_page.dart';
import 'package:flutter/material.dart';

class DashCamScreen extends StatefulWidget {
  const DashCamScreen({super.key});

  @override
  State<DashCamScreen> createState() => _DashCamScreenState();
}

class _DashCamScreenState extends State<DashCamScreen> {
  @override
  Widget build(BuildContext context) {
    return  VideoListPage();
  }
}
