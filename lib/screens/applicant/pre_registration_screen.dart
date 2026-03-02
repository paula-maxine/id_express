import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/address_model.dart';
import '../../data/model/application_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_providers.dart';
import '../../utils/tracking_utils.dart';

class PreRegistrationScreen extends ConsumerStatefulWidget {
  const PreRegistrationScreen({super.key});

  @override
  ConsumerState<PreRegistrationScreen> createState() => _PreRegistrationScreenState();
}

class _PreRegistrationScreenState extends ConsumerState<PreRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _nationality = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _parentName = TextEditingController();
  final TextEditingController _parentId = TextEditingController();

  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _fullName.dispose();
    _dob.dispose();
    _gender.dispose();
    _nationality.dispose();
    _address.dispose();
    _parentName.dispose();
    _parentId.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final uid = ref.read(authStateProvider).value!.uid;
      final tracking = generateTrackingRef();
      final now = DateTime.now();
      final application = ApplicationModel(
        id: '',
        applicantUid: uid,
        trackingRef: tracking,
        fullName: _fullName.text.trim(),
        dateOfBirth: DateTime.parse(_dob.text),
        gender: _gender.text.trim(),
        nationality: _nationality.text.trim(),
        address: AddressModel(
          district: _address.text.trim(),
          county: _address.text.trim(),
          subCounty: _address.text.trim(),
          parish: _address.text.trim(),
          village: _address.text.trim(),
        ),
        parentGuardianName: _parentName.text.trim().isEmpty ? null : _parentName.text.trim(),
        parentGuardianId: _parentId.text.trim().isEmpty ? null : _parentId.text.trim(),
        status: 'submitted',
        documentIds: [],
        createdAt: now,
        updatedAt: now,
      );
      final repo = ref.read(applicationRepositoryProvider);
      await repo.createApplication(application);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pre-registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullName,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _dob,
                decoration: const InputDecoration(labelText: 'Date of birth (YYYY-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _nationality,
                decoration: const InputDecoration(labelText: 'Nationality'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _parentName,
                decoration: const InputDecoration(labelText: 'Parent/Guardian Name (optional)'),
              ),
              TextFormField(
                controller: _parentId,
                decoration: const InputDecoration(labelText: 'Parent/Guardian ID (optional)'),
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
