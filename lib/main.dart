import 'package:airports_code/ap_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Apui(),
    ),
  );
}
