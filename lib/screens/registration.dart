// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:fintech/core/constants.dart';
import 'package:fintech/home_screen.dart';
import 'package:fintech/models/users_models.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  String _selectedUserType = 'sme';
  final Set<String> _selectedIndustries = {};

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        ref.read(userProvider.notifier).state = UserModel(
          userId: ref.read(userProvider).userId,
          email: ref.read(userProvider).email,
          phoneNumber: _phoneController.text.trim(),
          displayName: _nameController.text.trim(),
          role: _selectedUserType,
          profileCompleted: true,
        );
        // print(ref.read(userProvider).userId);
        print(ref.read(userProvider).toFirestore());
        // return;
        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(ref.read(userProvider).email)
            .set(ref.read(userProvider).toFirestore());
        showSnackBar(context, 'Registration successful');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
        return;
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message ?? 'Registration failed');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  // Title
                  Text(
                    'Create Your Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),

                  // User Type Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text('Investor'),
                        selectedColor: Colors.green,
                        selected: _selectedUserType == 'investor',
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedUserType = 'investor';
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      ChoiceChip(
                        label: Text('SME'),
                        selectedColor: Colors.green,
                        selected: _selectedUserType == 'sme',
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedUserType = 'sme';
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        // Optional phone number validation
                        if (!RegExp(
                                r'^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  const Text(
                    'Select Industry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  // const SizedBox(height: 10),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _selectIndustry,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 0, 57, 103)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _selectIndustry() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Select Industries'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                child: Wrap(
                  runAlignment: WrapAlignment.start,
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  runSpacing: 3,
                  children: industries.map((industry) {
                    final isSelected = _selectedIndustries.contains(industry);
                    return FilterChip(
                      selectedShadowColor: Colors.green,
                      selectedColor: Colors.green,
                      backgroundColor: Colors.grey[200],
                      label: Text(
                        industry,
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 12),
                      ),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedIndustries.add(industry);
                          } else {
                            _selectedIndustries.remove(industry);
                          }
                        });
                        setState(() {});
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
              child: Text('Register'),
              onPressed: () {
                if (_selectedIndustries.isNotEmpty) _register();

                if (_selectedIndustries.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                        'Minimum one industry must be selected',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                  );
                }
              })
        ],
      ),
      //   ],
      // ),
    );
  }
}
