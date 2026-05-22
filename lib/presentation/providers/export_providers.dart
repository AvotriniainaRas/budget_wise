import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/export_service.dart';

/// Fournit le service d'export.
final exportServiceProvider = Provider<ExportService>(
  (ref) => const ExportService(),
);