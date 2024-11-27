import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/models/opportunity_model.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmeApplicationPage extends ConsumerStatefulWidget {
  const SmeApplicationPage({super.key});

  @override
  ConsumerState<SmeApplicationPage> createState() => _SmeApplicationPageState();
}

class _SmeApplicationPageState extends ConsumerState<SmeApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _fundingNeededController =
      TextEditingController();
  final TextEditingController _minInvestmentController =
      TextEditingController();
  final TextEditingController _pitchController = TextEditingController();
  final TextEditingController _risksController = TextEditingController();
  String _selectedIndustry = 'Technology';

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(userProvider);

      final opportunity = OpportunityModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        smeId: user.userId ?? '',
        companyName: _companyNameController.text,
        industry: _selectedIndustry,
        fundingNeeded: double.parse(_fundingNeededController.text),
        fundingCurrent: 0,
        minInvestment: double.parse(_minInvestmentController.text),
        pitchDescription: _pitchController.text,
        risksAndChallenges: _risksController.text,
        status: 'open',
      );

      await FirebaseFirestore.instance
          .collection('opportunities')
          .doc(opportunity.id)
          .set(opportunity.toFirestore());

      showSnackBar(context, 'Application submitted successfully');
      Navigator.of(context).pop();
    } catch (e) {
      showSnackBar(context, 'Error submitting application: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Funding Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter company name' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIndustry,
                decoration: const InputDecoration(
                  labelText: 'Industry',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'Technology', child: Text('Technology')),
                  DropdownMenuItem(
                      value: 'Healthcare', child: Text('Healthcare')),
                  DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                  // Add more industries as needed
                ],
                onChanged: (value) {
                  setState(() => _selectedIndustry = value!);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fundingNeededController,
                decoration: const InputDecoration(
                  labelText: 'Funding Amount Needed (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter amount';
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _minInvestmentController,
                decoration: const InputDecoration(
                  labelText: 'Minimum Investment Amount (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter amount';
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pitchController,
                decoration: const InputDecoration(
                  labelText: 'Business Pitch',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your pitch' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _risksController,
                decoration: const InputDecoration(
                  labelText: 'Risks and Challenges',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter risks' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitApplication,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _fundingNeededController.dispose();
    _minInvestmentController.dispose();
    _pitchController.dispose();
    _risksController.dispose();
    super.dispose();
  }
}
