/// Central barrel export for all app packages and modules
library;

///* Flutter & packages
export 'package:flutter/material.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:go_router/go_router.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:intl/intl.dart' hide TextDirection;

///* Firebase
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';
export 'package:firebase_messaging/firebase_messaging.dart';

///* Utilities
export 'package:uuid/uuid.dart';
export 'package:image_picker/image_picker.dart';
export 'package:file_picker/file_picker.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:flutter_svg/flutter_svg.dart';

///* App modules
export 'app/exporter.dart';
export 'core/exporter.dart' hide required;
export 'features/exporter.dart';
export 'routes/exporter.dart';
