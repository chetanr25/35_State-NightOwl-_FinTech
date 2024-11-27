import 'package:fintech/models/users_models.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel _user;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
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
                backgroundImage: _user.profileImageUrl != null
                    ? NetworkImage(_user.profileImageUrl!)
                    : null,
                child: _user.profileImageUrl == null
                    ? Icon(Icons.person, size: 60)
                    : null,
              ),
              SizedBox(height: 16),
              Text(
                _user.name,
                // style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                _user.email,
                // style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 16),
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
            _buildDetailRow('User Type',
                _user.userType == UserType.sme ? 'SME' : 'Investor'),
            if (_user.companyName != null)
              _buildDetailRow('Company', _user.companyName!),
            if (_user.industry != null)
              _buildDetailRow('Industry', _user.industry!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  initialValue: _user.name,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Update name logic
                  },
                ),
                // Add more fields for editing profile
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Save Profile'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement profile update logic
      Navigator.of(context).pop();
    }
  }
}
// Last edited just now