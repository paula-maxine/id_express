import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/appointment_model.dart';
import '../../../data/model/service_centre_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/service_centre_provider.dart';
import '../../../providers/service_providers.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({super.key, required this.applicationId});

  final String applicationId;

  @override
  ConsumerState<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  ServiceCentreModel? _selectedCentre;
  DateTime? _selectedDate;
  bool _saving = false;
  String? _error;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      initialDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedCentre == null || _selectedDate == null) {
      setState(() {
        _error = 'Please select centre and date';
      });
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final uid = ref.read(authStateProvider).value!.uid;
      // generate token will occur in service
      final appointment = AppointmentModel(
        id: '',
        applicationId: widget.applicationId,
        applicantUid: uid,
        serviceCentreId: _selectedCentre!.id,
        dateTime: _selectedDate!,
        queueToken: '',
        status: 'scheduled',
        createdAt: DateTime.now(),
      );
      final appointmentService = ref.read(appointmentCloudServiceProvider);
      await appointmentService.createAppointment(appointment);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final centresAsync = ref.watch(serviceCentresProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: centresAsync.when(
          data: (centres) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Service Centre'),
              DropdownButton<ServiceCentreModel>(
                value: _selectedCentre,
                hint: const Text('Select centre'),
                items: centres
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedCentre = v;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text('Date'),
              Row(
                children: [
                  Text(_selectedDate == null
                      ? 'No date chosen'
                      : _selectedDate!.toLocal().toString().split(' ')[0]),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text('Book'),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error loading centres: $e')),
        ),
      ),
    );
  }
}
