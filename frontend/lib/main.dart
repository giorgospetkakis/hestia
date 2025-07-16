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
  List<Map<String, dynamic>> _routesStatus = [];
  Map<String, dynamic>? _healthDetails;

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
      
      // Get detailed health check
      final healthDetails = await apiService.healthCheckDetailed();
      
      // Get all routes status
      final routesStatus = await apiService.getAllRoutesStatus();
      
      // Get meals if API is healthy
      List<Map<String, dynamic>> meals = [];
      if (healthDetails['status'] == 'healthy') {
        try {
          meals = await apiService.getMeals();
        } catch (e) {
          // Meals might fail even if health check passes
        }
      }
      
      setState(() {
        _apiStatus = healthDetails['status'] == 'healthy' ? 'Connected' : 'Unhealthy';
        _healthDetails = healthDetails;
        _routesStatus = routesStatus;
        _meals = meals;
      });
    } catch (e) {
      setState(() {
        _apiStatus = 'Error: $e';
        _healthDetails = {
          'status': 'error',
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        };
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
                    
                    // Health Details
                    if (_healthDetails != null) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Health Check Details:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Status: ${_healthDetails!['status']}'),
                      if (_healthDetails!['statusCode'] != null)
                        Text('HTTP Code: ${_healthDetails!['statusCode']}'),
                      if (_healthDetails!['data'] != null) ...[
                        Text('Response: ${_healthDetails!['data']}'),
                      ],
                      if (_healthDetails!['error'] != null) ...[
                        Text('Error: ${_healthDetails!['error']}', 
                             style: const TextStyle(color: Colors.red)),
                      ],
                      Text('Timestamp: ${_healthDetails!['timestamp']}'),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // API Routes Status
            if (_routesStatus.isNotEmpty) ...[
              const Text(
                'API Routes Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...(_routesStatus.map((route) => Card(
                child: ListTile(
                  leading: Icon(
                    route['status'] == 'online' ? Icons.check_circle : Icons.error,
                    color: route['status'] == 'online' ? Colors.green : Colors.red,
                  ),
                  title: Text(route['route']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${route['status']}'),
                      if (route['statusCode'] != null)
                        Text('HTTP: ${route['statusCode']}'),
                      if (route['error'] != null)
                        Text('Error: ${route['error']}', 
                             style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  trailing: route['status'] == 'online' 
                    ? const Icon(Icons.signal_cellular_4_bar, color: Colors.green)
                    : const Icon(Icons.signal_cellular_off, color: Colors.red),
                ),
              )).toList()),
              const SizedBox(height: 20),
            ],
            
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _checkApiStatus,
            backgroundColor: Colors.blue,
            mini: true,
            child: const Icon(Icons.api, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: _checkApiStatus,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
