import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qnote/app.dart';
import 'package:qnote/core/services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await WidgetService.initialize();
  runApp(
    const ProviderScope(
      child: QnoteApp(),
    ),
  );
}
