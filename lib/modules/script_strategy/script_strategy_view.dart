import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'script_strategy_controller.dart';

class ScriptStrategyView extends GetView<ScriptStrategyController> {
  const ScriptStrategyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Script & Strategy',
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final items = controller.strategies;
            if (items.isEmpty) {
              return Center(
                child: Text(
                  'No strategies available.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  color: theme.cardColor.withOpacity(0.4),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(
                      items[index],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.playlist_add_check, color: Colors.white70),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
