import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../services/firebase_real_time.dart';
import '../../services/get_it.dart';

class SendSupportPage extends StatefulWidget {
  const SendSupportPage({super.key});

  @override
  State<SendSupportPage> createState() => _SendSupportPageState();
}

class _SendSupportPageState extends State<SendSupportPage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController topicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Send Support'),
        ),
        body:  SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: topicController,
                    decoration: const InputDecoration(
                      labelText: 'Topic',
                      border: OutlineInputBorder(),
                    ),
                  ),
                   const SizedBox(height: 16,),
                  TextFormField(
                    controller: messageController,
                    maxLines: 8,
                    decoration:  const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(onPressed: ()async{
            if( topicController.text.isEmpty || messageController.text.isEmpty){
              EasyLoading.showError('Please enter topic and message', duration: const Duration(seconds: 2));
              return;
            }
            EasyLoading.show(status: 'Sending...');
            await Future.delayed(const Duration(seconds: 1));
            getIt<FirebaseRealTimeDB>().putSupportMessage(topicController.text, messageController.text);
            EasyLoading.showSuccess('Sent successfully', duration: const Duration(seconds: 2));
            Navigator.pop(context);
          }, child: const Text('Send'))
      )),
    );
  }
}
