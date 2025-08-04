import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/search_history_model.dart';
import 'package:weather_app/services/firestore_service.dart';
import 'package:weather_app/services/auth_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<SearchHistory>> _historyFuture;

  @override
  void initState() {
    super.initState();
    final user = AuthService().currentUser;
    if (user != null) {
      _historyFuture = FirestoreService().getSearchHistory(user.uid).first;
    } else {
      _historyFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search History')),
      body: FutureBuilder<List<SearchHistory>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading history'));
          }

          final historyItems = snapshot.data ?? [];

          if (historyItems.isEmpty) {
            return Center(child: Text('No search history yet'));
          }

          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final item = historyItems[index];
              return Dismissible(
                key: Key(item.id),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  FirestoreService().deleteSearchHistory(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted ${item.cityName}')),
                  );
                },
                child: ListTile(
                  title: Text(item.cityName),
                  subtitle: Text(item.timestamp.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      FirestoreService().deleteSearchHistory(item.id);
                      setState(() {
                        _historyFuture = FirestoreService()
                            .getSearchHistory(AuthService().currentUser!.uid)
                            .first;
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
