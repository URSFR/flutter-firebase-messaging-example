import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasemessagingdemo/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class NotifScreen extends StatefulWidget {
  const NotifScreen({super.key});

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  @override
  Widget build(BuildContext context) {

    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (controller) {
            controller.initializeFCM();

            return Column(children: [
            Container(
                width: 400,
                child: TextFormField(controller: textEditingController,)),
            ElevatedButton(onPressed: (){
              if(textEditingController.text.isEmpty){
                null;
              }else{
                controller.sendMessage(textMessage: textEditingController.text);
              }
            }, child: const Text("SEND MESSAGE TO MYSELF")),
          ],);
          },
        ),
      ),
    );
  }
}

