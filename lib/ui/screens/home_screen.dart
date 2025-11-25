import 'package:flutter/material.dart';
import '../../services/service_locator.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../widgets/user_card.dart';
import 'user_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = getIt<ApiService>();
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final users = await _apiService.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToUserDetail(User user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(userId: user.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            key: const Key('refresh_button'),
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadUsers,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(key: Key('loading_indicator'), child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        key: const Key('error_message'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text('Error loading users', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadUsers, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_users.isEmpty) {
      return const Center(key: Key('empty_state'), child: Text('No users found'));
    }
    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.builder(
        key: const Key('user_list'),
        padding: const EdgeInsets.all(8),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return UserCard(key: Key('user_card_${user.id}'), user: user, onTap: () => _navigateToUserDetail(user));
        },
      ),
    );
  }
}
