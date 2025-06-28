import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});
  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool agreedTOU = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xffD7E9EC),
          gradient: LinearGradient(colors: [
            Color(0xffD7E9EC),
            Color(0xffD9EAED),
            Color(0xffF1F4F5),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        padding: const EdgeInsets.only(left: 10, top: 70, right: 10),
        child: Center(
          child: Text(
            'Something went wrong',
            style: const TextStyle(color: Color(0xff1F2E4C), fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      )),
    );
  }
}
