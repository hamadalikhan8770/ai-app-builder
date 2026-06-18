import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/core/widgets/error_view.dart';
import 'package:my_first_app/core/widgets/loading_view.dart';
import 'package:my_first_app/features/ai_generation/models/generated_output_model.dart';
import 'package:my_first_app/features/ai_generation/providers/generated_output_providers.dart';
import 'package:my_first_app/features/export/providers/export_providers.dart';
import 'package:my_first_app/features/export/widgets/export_action_button.dart';
import 'package:my_first_app/routing/route_names.dart';

class GeneratedOutputDetailScreen extends ConsumerWidget {
  const GeneratedOutputDetailScreen({super.key, required this.outputId});

  final String outputId;

  Future<void> _copyText(
    BuildContext context,
    GeneratedOutputModel output,
  ) async {
    await Clipboard.setData(ClipboardData(text: output.content));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard.')));
  }

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

  void _showExportResult(BuildContext context, WidgetRef ref) {
    final state = ref.read(exportControllerProvider);
    if (state.errorMessage == 'upgrade_required') {
      _showUpgradeDialog(context);
      return;
    }

    final message = state.errorMessage ?? state.successMessage;
    if (message == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: state.errorMessage == null ? null : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputAsync = ref.watch(generatedOutputByIdProvider(outputId));
    final exportState = ref.watch(exportControllerProvider);

    return outputAsync.when(
      loading: () => const LoadingView(message: 'Loading generated output...'),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Generated Output')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: ErrorView(message: error.toString()),
        ),
      ),
      data: (output) {
        if (output == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Generated Output')),
            body: const Padding(
              padding: EdgeInsets.all(24),
              child: ErrorView(message: 'Output not found.'),
            ),
          );
        }

        final date = DateFormat(
          'MMM d, yyyy • h:mm a',
        ).format(output.createdAt);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Generated Output'),
            actions: [
              IconButton(
                onPressed: () => _copyText(context, output),
                icon: const Icon(Icons.copy_rounded),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        output.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        output.outputType.replaceAll('_', ' ').toUpperCase(),
                      ),
                      const SizedBox(height: 4),
                      Text(date),
                      if (output.aiProvider != null ||
                          output.modelName != null) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (output.aiProvider != null)
                              Chip(label: Text(output.aiProvider!)),
                            if (output.modelName != null)
                              Chip(label: Text(output.modelName!)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ExportActionButton(
                    icon: Icons.copy_rounded,
                    label: 'Copy Text',
                    onPressed: () => _copyText(context, output),
                    isPrimary: true,
                  ),
                  ExportActionButton(
                    icon: Icons.picture_as_pdf_outlined,
                    label: 'Preview PDF',
                    isLoading: exportState.isLoading,
                    onPressed: () async {
                      await ref
                          .read(exportControllerProvider.notifier)
                          .preview(output);
                      if (context.mounted) _showExportResult(context, ref);
                    },
                  ),
                  ExportActionButton(
                    icon: Icons.ios_share_rounded,
                    label: 'Share PDF',
                    isLoading: exportState.isLoading,
                    onPressed: () async {
                      await ref
                          .read(exportControllerProvider.notifier)
                          .share(output);
                      if (context.mounted) _showExportResult(context, ref);
                    },
                  ),
                  ExportActionButton(
                    icon: Icons.download_rounded,
                    label: 'Save PDF',
                    isLoading: exportState.isLoading,
                    onPressed: () async {
                      await ref
                          .read(exportControllerProvider.notifier)
                          .save(output);
                      if (context.mounted) _showExportResult(context, ref);
                    },
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.pushNamed(
                      RouteNames.pdfPreview,
                      pathParameters: {'id': output.id},
                    ),
                    icon: const Icon(Icons.visibility_rounded),
                    label: const Text('Open Preview Screen'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: SelectableText(
                    output.content.trim().isEmpty
                        ? 'No generated content is available for this output.'
                        : output.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.55,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
