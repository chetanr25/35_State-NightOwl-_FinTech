import 'package:fintech/models/users_models.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _saveProfile(String name) {
    _user = _user.copyWith(displayName: name);
    ref.read(userProvider.notifier).updateProfile(_user);
    setState(() {
      _user = _user.copyWith(displayName: name);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                // ignore: unnecessary_null_comparison
                backgroundImage: _user.profileImageUrl != null
                    ? NetworkImage(_user.profileImageUrl)
                    : null,
                // ignore: unnecessary_null_comparison
                child: _user.profileImageUrl == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                _user.displayName ?? '',
              ),
              Text(
                _user.email ?? '',
              ),
              const SizedBox(height: 16),
              _buildProfileDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', _user.displayName ?? ''),
            const SizedBox(height: 8),
            _buildDetailRow('Email', _user.email ?? ''),
            const SizedBox(height: 8),
            _buildDetailRow('Role', _user.role ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        TextEditingController nameController =
            TextEditingController(text: _user.displayName);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: nameController,
              ),
              // Add more fields for editing profile
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    _saveProfile(nameController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Name cannot be empty'),
                      ),
                    );
                  }
                },
                child: const Text('Save Profile'),
              )
            ],
          ),
        );
      },
    );
  }
}
// Last edited just now