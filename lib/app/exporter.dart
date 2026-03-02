import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'id_express.dart';

export 'id_express.dart';

final idExpressProvider = Provider<IdExpress>((ref) {
  return const IdExpress();
});
