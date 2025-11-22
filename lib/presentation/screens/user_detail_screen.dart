import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../data/models/user.dart';
import '../../data/services/api_service.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final ApiService _apiService = getIt<ApiService>();

  User? _user;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = await _apiService.getUserById(widget.userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        key: Key('loading_indicator'),
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        key: const Key('error_message'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading user details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUser,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_user == null) {
      return const Center(
        key: Key('empty_state'),
        child: Text('User not found'),
      );
    }

    return SingleChildScrollView(
      key: const Key('user_detail_content'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Personal Information',
            children: [
              _buildInfoRow('Name', _user!.name),
              _buildInfoRow('Username', _user!.username),
              _buildInfoRow('Email', _user!.email),
              _buildInfoRow('Phone', _user!.phone),
              _buildInfoRow('Website', _user!.website),
            ],
          ),
          if (_user!.address != null) ...[
            const SizedBox(height: 24),
            _buildSection(
              title: 'Address',
              children: [
                _buildInfoRow('Street', '${_user!.address!.street}, ${_user!.address!.suite}'),
                _buildInfoRow('City', _user!.address!.city),
                _buildInfoRow('Zipcode', _user!.address!.zipcode),
                if (_user!.address!.geo != null)
                  _buildInfoRow('Location', 'Lat: ${_user!.address!.geo!.lat}, Lng: ${_user!.address!.geo!.lng}'),
              ],
            ),
          ],
          if (_user!.company != null) ...[
            const SizedBox(height: 24),
            _buildSection(
              title: 'Company',
              children: [
                _buildInfoRow('Name', _user!.company!.name),
                _buildInfoRow('Catch Phrase', _user!.company!.catchPhrase),
                _buildInfoRow('Business', _user!.company!.bs),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              key: Key('${label.toLowerCase().replaceAll(' ', '_')}_value'),
            ),
          ),
        ],
      ),
    );
  }
}
