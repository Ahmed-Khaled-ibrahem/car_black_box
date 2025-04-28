import 'package:car_black_box/models/car.dart';
import 'package:car_black_box/services/firebase_real_time.dart';
import 'package:car_black_box/services/get_it.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RecordPage extends StatefulWidget {
   RecordPage( this.car, {super.key});
  @override
  State<RecordPage> createState() => _RecordPageState();
  Car car;
}

class _RecordPageState extends State<RecordPage> with SingleTickerProviderStateMixin{
  bool isRecording = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 1.0,
      upperBound: 1.2,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
    getIt<FirebaseRealTimeDB>().setRecord(widget.car.id, isRecording ? 1 : 2);

    if (isRecording) {
      _animationController.forward();
    } else {
      _animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/cam.json', height: 250, width: 250,),
          const Text('You Can Record Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animationController,
                child: GestureDetector(
                  onTap: toggleRecording,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRecording ? Colors.red : Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: (isRecording ? Colors.red : Colors.blue).withOpacity(0.6),
                            spreadRadius: 8,
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: Icon(
                        isRecording ? Icons.stop : Icons.play_arrow_sharp,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(width: 20,),
              Text(
                isRecording ? "Recording in progress..." : "Tap to start recording",
                style: TextStyle(
                  fontSize: 16,
                  color: isRecording ? Colors.red : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
