import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/search_history_model.dart';

class SearchHistoryItem extends StatelessWidget {
  final SearchHistory item;
  final VoidCallback onDelete;

  const SearchHistoryItem({
    Key? key,
    required this.item,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(item.cityName, style: const TextStyle(fontSize: 18)),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - HH:mm').format(item.timestamp),
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
