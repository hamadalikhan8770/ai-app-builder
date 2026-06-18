import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/core/widgets/error_view.dart';
import 'package:my_first_app/core/widgets/loading_view.dart';
import 'package:my_first_app/features/ai_generation/providers/generated_output_providers.dart';
import 'package:my_first_app/features/export/providers/export_providers.dart';
import 'package:my_first_app/routing/route_names.dart';
import 'package:printing/printing.dart';

class PdfPreviewScreen extends ConsumerWidget {
  const PdfPreviewScreen({super.key, required this.outputId});

  final String outputId;

  Future<void> _showUpgradeDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          'PDF export is available for Premium users. Upgrade to Premium to download and share generated app plans.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pushNamed(RouteNames.upgrade);
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputAsync = ref.watch(generatedOutputByIdProvider(outputId));

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Preview')),
      body: outputAsync.when(
        loading: () => const LoadingView(message: 'Loading output...'),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(24),
          child: ErrorView(message: error.toString()),
        ),
        data: (output) {
          if (output == null) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: ErrorView(message: 'Output not found.'),
            );
          }

          return FutureBuilder<Uint8List?>(
            future: ref
                .read(exportControllerProvider.notifier)
                .buildPdf(output),
            builder: (context, snapshot) {
              final exportState = ref.read(exportControllerProvider);

              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingView(message: 'Preparing PDF preview...');
              }

              if (exportState.errorMessage == 'upgrade_required') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) _showUpgradeDialog(context);
                });
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          size: 52,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'PDF preview is a Premium feature.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () =>
                              context.pushNamed(RouteNames.upgrade),
                          child: const Text('Upgrade'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final bytes = snapshot.data;
              if (bytes == null || bytes.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: ErrorView(
                    message:
                        exportState.errorMessage ??
                        'Could not generate PDF preview.',
                  ),
                );
              }

              final service = ref.watch(pdfExportServiceProvider);
              return PdfPreview(
                build: (_) async => bytes,
                pdfFileName: service.buildFileName(output),
                canChangeOrientation: false,
                canChangePageFormat: false,
                allowPrinting: true,
                allowSharing: true,
              );
            },
          );
        },
      ),
    );
  }
}
