import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/hive_datasource.dart';

/// Fournit l'instance singleton de [HiveDatasource].
///
/// Toute la couche data passe par ce provider —
/// jamais d'instanciation directe dans les widgets.
final hiveDatasourceProvider = Provider<HiveDatasource>(
  (ref) => HiveDatasource.instance,
);