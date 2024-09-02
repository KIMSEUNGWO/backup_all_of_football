
import 'package:flutter/material.dart';

class SettingsNoticeWidget extends StatefulWidget {
  const SettingsNoticeWidget({super.key});

  @override
  State<SettingsNoticeWidget> createState() => _SettingsNoticeWidgetState();
}

class _SettingsNoticeWidgetState extends State<SettingsNoticeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
