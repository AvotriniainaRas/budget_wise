import 'package:flutter/material.dart';

/// Ouvre un date picker compatible avec go_router.
///
/// Utilise le navigator racine pour éviter le conflit
/// entre le navigator de go_router et celui du dialog.
Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime     initialDate,
  required DateTime     firstDate,
  required DateTime     lastDate,
}) async {
  return showDatePicker(
    context:   context,
    initialDate: initialDate,
    firstDate:   firstDate,
    lastDate:    lastDate,
    builder: (ctx, child) {
      return Theme(
        data: Theme.of(context),
        child: child!,
      );
    },
  );
}