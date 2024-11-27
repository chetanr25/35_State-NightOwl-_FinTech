// ignore_for_file: prefer_const_constructors

import 'package:fintech/core/constants.dart';
import 'package:fintech/home_screen.dart';
import 'package:fintech/models/users_models.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal Details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _companyNameController = TextEditingController();

  bool _isLoading = false;

  String _selectedUserType = 'sme';
  final Set<String> _selectedIndustries = {};

  // List<String> _industries = const [
  //   'Technology',
  //   'Finance',
  //   'Healthcare',
  //   'Agriculture',
  //   'Education',
  //   'Retail',
  //   'Other'
  // ];
  String? _selectedIndustry;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // // Create user in Firebase Authentication
        // UserCredential userCredential = await FirebaseAuth.instance
        //     .createUserWithEmailAndPassword(
        //         email: _emailController.text.trim(),
        //         password: _passwordController.text.trim());

        // Create user profile in Firestore
        UserModel newUser = UserModel(
          displayName: _nameController.text.trim(),
          role: _selectedUserType,
          profileCompleted: false,
          // companyName: _companyNameController.text.trim().isEmpty
          //     ? null
          //     : _companyNameController.text.trim(),
          // industry: _selectedIndustry,
        );
        print(ref.read(userProvider).userId);
        print(newUser.toFirestore());
        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(ref.read(userProvider).userId)
            .set(newUser.toFirestore());

        // Navigate to home or onboarding
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (_) => HomePage())
        // );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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

                // Name Input
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
                // const SizedBox(height: 20),

                // Email Input

                SizedBox(height: 20),

                // Phone Input
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
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
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

                // Login Link
                // Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                // children: [
                //   const Text('Already have an account? '),
                //   TextButton(
                //     onPressed: () {
                //       _selectIndustry();
                //       // Navigate to login screen
                //       // Navigator.of(context).pushReplacement(
                //       //   MaterialPageRoute(builder: (_) => LoginScreen())
                //       // );
                //     },
                //     child: const Text(
                //       'Login',
                //       style: TextStyle(),
                //     ),
                //   ),
                // ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    // _companyNameController.dispose();
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
            return Container(
              // constraints: BoxConstraints(
              //   maxHeight: 200,
              // ),
              // width: MediaQuery.of(context).size.width * 0.7,
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
                      },
                      // selectedColor: Colors.green,
                      // checkmarkColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        // side: BorderSide(
                        //   color: isSelected
                        //       ? Theme.of(context).primaryColor
                        //       : Colors.transparent,
                        // ),
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
  // void _selectIndustry() {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text('Select Industry'),
  //       content: Wrap(
  //         spacing: 4,
  //         runSpacing: 3,
  //         children: industries.map((industry) {
  //           final isSelected = _selectedIndustry == industry;
  //           return FilterChip(
  //             selectedShadowColor: Colors.green,
  //             backgroundColor: Colors.grey[200],
  //             label: Text(
  //               industry,
  //               style: TextStyle(
  //                   color: isSelected ? Colors.white : Colors.black87,
  //                   fontSize: 10),
  //             ),
  //             selected: isSelected,
  //             onSelected: (bool selected) {
  //               setState(() {
  //                 _selectedIndustry = selected ? industry : null;
  //               });
  //             },
  //             selectedColor: Theme.of(context).primaryColor,
  //             // backgroundColor: Colors.grey[200],
  //             checkmarkColor: Colors.white,
  //             padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               side: BorderSide(
  //                 color: isSelected
  //                     ? Theme.of(context).primaryColor
  //                     : Colors.transparent,
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             FocusScope.of(context).unfocus();
  //             Navigator.pushReplacement(
  //                 context, MaterialPageRoute(builder: (_) => HomePage()));
  //           },
  //           child: Text('Done'),
  //         ),
  //       ],
  //     ),
  //   );

  // }
// }
