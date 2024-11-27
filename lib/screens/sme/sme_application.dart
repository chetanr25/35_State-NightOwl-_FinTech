import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

class SmeApplicationScreen extends StatefulWidget {
  const SmeApplicationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SmeApplicationScreenState createState() => _SmeApplicationScreenState();
}

class _SmeApplicationScreenState extends State<SmeApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text inputs
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fundingGoalController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _businessPlanController = TextEditingController();

  // Lists for dynamic inputs
  List<String> _tags = [];
  List<String> _financialDocuments = [];
  final TextEditingController _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create SME Opportunity'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          onVerticalDragCancel: () => FocusScope.of(context).unfocus(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildTextFormField(
                controller: _titleController,
                label: 'Company name',
                hint: 'Enter your product title',
                validator: (value) =>
                    value!.isEmpty ? 'Title is required' : null,
              ),
              _buildMultilineTextFormField(
                controller: _descriptionController,
                label: 'Description of the product',
                hint: 'Provide a detailed description of your product',
                validator: (value) =>
                    value!.isEmpty ? 'Description is required' : null,
              ),
              _buildNumberFormField(
                controller: _fundingGoalController,
                label: 'Funding goal',
                hint: 'Enter the total funding amount needed',
                validator: (value) =>
                    value!.isEmpty ? 'Funding goal is required' : null,
              ),
              _buildTextFormField(
                controller: _industryController,
                label: 'Industry',
                hint: 'Enter your industry',
                validator: (value) =>
                    value!.isEmpty ? 'Industry is required' : null,
              ),
              _buildTagsSection(),
              const SizedBox(height: 16),
              _buildMultilineTextFormField(
                controller: _businessPlanController,
                label: 'Business Plan',
                hint: 'Provide an overview of your business plan',
              ),
              _buildDocumentUploadSection(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: _submitApplication,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit Opportunity',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildMultilineTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildNumberFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: '\$',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Tags',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // validator: validator,
                controller: _tagController,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _addTag,
            ),
          ],
        ),
        Wrap(
          spacing: 4,
          children: _tags
              .map((tag) => Chip(
                    backgroundColor: Colors.blue,
                    labelStyle: const TextStyle(color: Colors.white),
                    avatar: const Icon(Icons.tag, color: Colors.white),
                    label: Text(tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                    onDeleted: () => _removeTag(tag),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDocumentUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Documents',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: _uploadDocument,
          icon: Icon(Icons.upload_file),
          label: Text('Upload Document'),
        ),
        Wrap(
          spacing: 8,
          children: _financialDocuments
              .map((doc) => Chip(
                    label: Text(doc.split('/').last),
                    onDeleted: () => _removeDocument(doc),
                  ))
              .toList(),
        ),
      ],
    );
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _financialDocuments.add(result.files.single.path!);
      });
    }
  }

  void _removeDocument(String document) {
    setState(() {
      _financialDocuments.remove(document);
    });
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      // Prepare data for Firestore
      final userId = DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          (100000 + Random().nextInt(900000)).toString();
      final encodedUserId = base64Encode(utf8.encode(userId));
      print(encodedUserId);
      final smeData = {
        'smeId': encodedUserId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'fundingGoal': double.parse(_fundingGoalController.text),
        'currentFunding': 0.0,
        'industry': _industryController.text,
        'tags': _tags,
        'createdAt': DateTime.now(),
        'businessPlan': _businessPlanController.text,
        'financialDocuments': _financialDocuments,
      };

      try {
        await FirebaseFirestore.instance.collection('smes').add(smeData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opportunity submitted successfully')),
        );
        Navigator.pop(context);

        // Optional: Navigate back or reset form
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting opportunity: $e')),
        );
      }
    }
  }
}
