import 'package:flutter/material.dart';
import '../../models/enums.dart';

/// Service type model for applicant home screen
class ServiceType {
  /// Creates a service type
  const ServiceType({
    required this.title,
    required this.description,
    required this.icon,
    required this.applicationType,
    this.isEnabled = true,
  });

  /// Service title
  final String title;

  /// Short description
  final String description;

  /// Icon to display
  final IconData icon;

  /// The application type this service maps to
  final ApplicationType applicationType;

  /// Whether this service is currently available
  final bool isEnabled;

  /// All available services
  static List<ServiceType> get allServices => const [
    ServiceType(
      title: 'New Registration',
      description: 'Apply for your first National ID',
      icon: Icons.person_add_rounded,
      applicationType: ApplicationType.newRegistration,
    ),
    ServiceType(
      title: 'Renewal',
      description: 'Renew your existing National ID',
      icon: Icons.autorenew_rounded,
      applicationType: ApplicationType.renewal,
    ),
    ServiceType(
      title: 'Replacement',
      description: 'Replace a lost or damaged ID',
      icon: Icons.credit_card_rounded,
      applicationType: ApplicationType.replacement,
    ),
    ServiceType(
      title: 'Change of Particulars',
      description: 'Update your personal information',
      icon: Icons.edit_note_rounded,
      applicationType: ApplicationType.changeOfParticulars,
    ),
  ];
}
