import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/search_history_model.dart';
import 'package:weather_app/services/auth_service.dart';
import 'package:weather_app/services/firestore_service.dart';
import 'package:weather_app/widgets/search_history_item.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.getCurrentUser();
    final firestoreService = FirestoreService();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Search History')),
        body: const Center(
          child: Text('You need to be logged in to view history'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Search History')),
      body: StreamBuilder<List<SearchHistory>>(
        stream: firestoreService.getSearchHistory(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No search history yet'));
          }

          final historyItems = snapshot.data!;

          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final item = historyItems[index];
              return SearchHistoryItem(
                item: item,
                onDelete: () => firestoreService.deleteSearchHistory(item.id),
              );
            },
          );
        },
      ),
    );
  }
}
