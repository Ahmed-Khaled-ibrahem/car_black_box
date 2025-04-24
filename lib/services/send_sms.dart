import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:another_telephony/telephony.dart';
import '../views/car_screens/emergency/emergency_contact.dart';

class SendSms{

  final Telephony telephony = Telephony.instance;
  var emergencyBox = Hive.box<EmergencyContact>('emergency_contacts');

  void sendToContacts() async {
    String message = "Accident alert!\nLocation: https://maps.app.goo.gl/DyNPETjZ8L6XFdkK8";
    if( emergencyBox.isEmpty){
      EasyLoading.showToast("No emergency contacts added");
    }
    for (var contact in emergencyBox.values) {
      sendSMS(contact.phone, message);
    }
  }
  // Function to request SMS permission
  Future<bool> _requestSmsPermission() async {
    if (await Permission.sms.isGranted) {
      return true;
    }
    var status = await Permission.sms.request();
    return status.isGranted;
  }
  // Function to send SMS
  Future<void> sendSMS(phoneNumber, message) async {
    bool? canSend = await telephony.isSmsCapable;
    if (!canSend!) {
      EasyLoading.showToast("Device cannot send SMS");
      return;
    }
    bool hasPermission = await _requestSmsPermission();
    if (hasPermission) {
      try {
        await telephony.sendSms(
          to: phoneNumber,
          message: message,
          statusListener: (SendStatus status) {
            String statusMessage = status == SendStatus.SENT
                ? "SMS Sent Successfully"
                : "SMS Failed to Send";
            EasyLoading.showToast(statusMessage);
          },
        );
      } catch (e) {
        EasyLoading.showToast("Error sending SMS: $e");
      }
    } else {
      EasyLoading.showToast( "SMS permission denied");
    }
  }

}