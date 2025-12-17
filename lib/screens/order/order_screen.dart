import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailor_app/data/api_service.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Get.find<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List (Debug Users)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Simple way to refresh: force rebuild if needed or just navigation
              // For now, setState isn't available in Stateless, so we rely on hot reload or re-entering page
              // A real implementation would use a Controller with RxList
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: apiService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          List users = [];
          if (snapshot.data is List) {
            users = snapshot.data as List;
          } else if (snapshot.data is Map &&
              (snapshot.data as Map).containsKey('results')) {
            // Handle Django pagination or wrapped response
            users = (snapshot.data as Map)['results'];
          } else {
            return Center(
              child: Text(
                'Unexpected data format: ${snapshot.data.runtimeType}',
              ),
            );
          }

          if (users.isEmpty) {
            return const Center(child: Text('User list is empty'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (user['email'] != null &&
                              user['email'].toString().isNotEmpty)
                          ? user['email'][0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(user['email'] ?? 'No Email'),
                  subtitle: Text('Role: ${user['role'] ?? 'Unknown'}'),
                  trailing: Text(user['id'].toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
