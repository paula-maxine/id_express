import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/document_model.dart';
import '../providers/service_providers.dart';
import '../services/auth_service.dart';
import 'documents_list_screen.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final AuthService _authService = AuthService();
  // removed direct firestore/storage usage; use repository
  final ImagePicker _imagePicker = ImagePicker();

  final _fullNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  String? _selectedDocumentType = 'National ID';
  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _documentTypes = ['National ID', 'Passport', 'Driver License'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  Future<void> _uploadDocument() async {
    // Validate inputs
    if (_fullNameController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter full name');
      return;
    }
    if (_idNumberController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter ID number');
      return;
    }
    if (_selectedImage == null) {
      setState(() => _errorMessage = 'Please select an image');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final uid = _authService.currentUser!.uid;
      final repo = ref.read(documentRepositoryProvider);

      final document = DocumentModel(
        id: '',
        applicationId: uid,
        type: _selectedDocumentType!,
        fileName: _selectedImage!.path.split('/').last,
        imageUrl: '',
        fileSize: await _selectedImage!.length(),
        mimeType: 'image/jpeg',
        uploadedAt: DateTime.now(),
      );

      await repo.saveDocument(
        document: document,
        localFilePath: _selectedImage!.path,
      );

      setState(() {
        _fullNameController.clear();
        _idNumberController.clear();
        _selectedImage = null;
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Document queued for upload.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error uploading document: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Document'),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == 'logout') {
                  _logout();
                } else if (value == 'documents') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DocumentsListScreen(),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'documents',
                  child: Text('My Documents'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Upload Document',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Document Type
              const Text('Document Type'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedDocumentType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _documentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDocumentType = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Full Name
              const Text('Full Name'),
              const SizedBox(height: 8),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Enter your full name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              // ID Number
              const Text('ID Number'),
              const SizedBox(height: 8),
              TextField(
                controller: _idNumberController,
                decoration: InputDecoration(
                  labelText: 'Enter ID number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.card_giftcard),
                ),
              ),
              const SizedBox(height: 20),
              // Image Selection
              const Text('Document Image'),
              const SizedBox(height: 8),
              if (_selectedImage == null)
                GestureDetector(
                  onTap: _isLoading ? null : _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40),
                        SizedBox(height: 8),
                        Text('Tap to take photo'),
                      ],
                    ),
                  ),
                )
              else
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadDocument,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Upload Document',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
