// web_modules/web_home/web_home_controller.dart
import 'package:air_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as webHndle;
import 'dart:js_interop';

class WebHomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxInt activeItemIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void setActive(int i) => activeItemIndex.value = i;
  void setQuery(String q) => searchQuery.value = q.toLowerCase();

  @override
  void onInit() {
    super.onInit();
    _listenForUpdates();
  }

  void _listenForUpdates() {
    // Listen for the custom event dispatched from index.html
    webHndle.window.addEventListener(
      'flutter_version_update',
      ((webHndle.Event event) {
            _showUpdateNotification();
          }).toJS
          as webHndle.EventListener, // Explicitly cast the JS-interop object
    );
  }

  void _showUpdateNotification() {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: const Text('A new update is available!'),
        duration: const Duration(days: 1), // Keep open until actioned
        action: SnackBarAction(
          label: 'Refresh',
          onPressed: () {
            // Force reload the web page to load the new deployment
            webHndle.window.location.reload();
          },
        ),
      ),
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
