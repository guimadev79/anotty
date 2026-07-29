import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

class ReportActions extends StatelessWidget {
  final VoidCallback onPdf;
  final VoidCallback onShare;

  const ReportActions({
    super.key,
    required this.onPdf,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onPdf,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Exportar PDF'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.share),
            label: const Text('Compartilhar'),
          ),
        ),
      ],
    );
  }
}