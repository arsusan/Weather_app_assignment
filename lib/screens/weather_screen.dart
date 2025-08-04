import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/screens/account_screen.dart';
import 'package:weather_app/screens/history_screen.dart';
import 'package:weather_app/services/auth_service.dart';
import 'package:weather_app/services/firestore_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/loading_indicator.dart';
import 'package:weather_app/widgets/weather_card.dart';

class WeatherScreen extends StatefulWidget {
  final Weather initialWeather;

  const WeatherScreen({Key? key, required this.initialWeather})
    : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Weather _weather;
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService(
    apiKey: '8bbd47e936fda67e8974acbfb1b8c887',
  );
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _weather = widget.initialWeather;
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final cityName = _cityController.text.trim();
      if (cityName.isEmpty) throw Exception('Please enter a city name');

      final weather = await _weatherService.getWeather(cityName);
      final user = _authService.getCurrentUser();
      if (user != null) {
        await _firestoreService.addSearchHistory(user.uid, cityName);
      }

      setState(() => _weather = weather);
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (user != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Welcome, ${user.displayName ?? user.email}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Enter city name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _fetchWeather(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: const Text('Search'),
                ),
              ],
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const LoadingIndicator()
            else
              WeatherCard(weather: _weather),
          ],
        ),
      ),
    );
  }
}
