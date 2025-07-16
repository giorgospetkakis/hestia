import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const HestiaApp());
}

class HestiaApp extends StatelessWidget {
  const HestiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  String _apiStatus = 'Unknown';
  List<Map<String, dynamic>> _meals = [];

  @override
  void initState() {
    super.initState();
    _checkApiStatus();
  }

  Future<void> _checkApiStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final isHealthy = await apiService.healthCheck();
      
      if (isHealthy) {
        final meals = await apiService.getMeals();
        setState(() {
          _apiStatus = 'Connected';
          _meals = meals;
        });
      } else {
        setState(() {
          _apiStatus = 'Unhealthy';
        });
      }
    } catch (e) {
      setState(() {
        _apiStatus = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConfig.appName} - Your Daily Ritual'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 100,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Hestia',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your AI-powered nutrition assistant',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // API Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.api, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'API Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Status: $_apiStatus'),
                    Text('URL: ${AppConfig.apiBaseUrl}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Meals
            if (_meals.isNotEmpty) ...[
              const Text(
                'Available Meals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _meals.length,
                  itemBuilder: (context, index) {
                    final meal = _meals[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.restaurant, color: Colors.orange),
                        title: Text(meal['name'] ?? 'Unknown'),
                        subtitle: Text(meal['description'] ?? ''),
                        trailing: Chip(
                          label: Text(meal['type'] ?? ''),
                          backgroundColor: Colors.orange.shade100,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkApiStatus,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
