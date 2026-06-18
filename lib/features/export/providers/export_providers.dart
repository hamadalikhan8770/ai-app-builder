import 'dart:io';
import 'dart:typed_data';

import 'package:my_first_app/core/errors/app_exception.dart';
import 'package:my_first_app/features/ai_generation/models/generated_output_model.dart';
import 'package:my_first_app/features/auth/providers/auth_providers.dart';
import 'package:my_first_app/features/export/data/export_log_repository.dart';
import 'package:my_first_app/features/export/data/export_repository.dart';
import 'package:my_first_app/features/export/data/pdf_export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pdfExportServiceProvider = Provider<PdfExportService>((ref) {
  return PdfExportService();
});

final exportLogRepositoryProvider = Provider<ExportLogRepository>((ref) {
  return ExportLogRepository(ref.watch(supabaseClientProvider));
});

final exportRepositoryProvider = Provider<ExportRepository>((ref) {
  return ExportRepository(
    client: ref.watch(supabaseClientProvider),
    pdfExportService: ref.watch(pdfExportServiceProvider),
    exportLogRepository: ref.watch(exportLogRepositoryProvider),
  );
});

final exportControllerProvider =
    StateNotifierProvider<ExportController, ExportState>((ref) {
      return ExportController(ref.watch(exportRepositoryProvider));
    });

class ExportState {
  const ExportState({
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
    this.savedFile,
    this.pdfBytes,
  });

  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;
  final File? savedFile;
  final Uint8List? pdfBytes;

  bool get isUpgradeRequired =>
      errorMessage?.contains('upgrade_required') == true;
}

class ExportController extends StateNotifier<ExportState> {
  ExportController(this._repository) : super(const ExportState());

  final ExportRepository _repository;

  Future<bool> checkPermission() => _repository.checkExportPermission();

  Future<Uint8List?> buildPdf(GeneratedOutputModel output) async {
    state = const ExportState(isLoading: true);
    try {
      final bytes = await _repository.buildPdfForOutput(output);
      state = ExportState(pdfBytes: bytes, successMessage: 'PDF generated.');
      return bytes;
    } on AppException catch (error) {
      state = ExportState(errorMessage: _friendlyError(error));
      return null;
    } catch (_) {
      state = const ExportState(errorMessage: 'PDF generation failed.');
      return null;
    }
  }

  Future<bool> preview(GeneratedOutputModel output) async {
    return _run(
      () => _repository.previewOutputPdf(output),
      'PDF preview opened.',
    );
  }

  Future<bool> share(GeneratedOutputModel output) async {
    return _run(
      () => _repository.shareOutputPdf(output),
      'PDF share sheet opened.',
    );
  }

  Future<File?> save(GeneratedOutputModel output) async {
    state = const ExportState(isLoading: true);
    try {
      final file = await _repository.saveOutputPdf(output);
      state = ExportState(
        savedFile: file,
        successMessage: 'PDF saved to ${file.path}',
      );
      return file;
    } on AppException catch (error) {
      state = ExportState(errorMessage: _friendlyError(error));
      return null;
    } catch (_) {
      state = const ExportState(errorMessage: 'Could not save PDF.');
      return null;
    }
  }

  Future<bool> _run(Future<void> Function() action, String success) async {
    state = const ExportState(isLoading: true);
    try {
      await action();
      state = ExportState(successMessage: success);
      return true;
    } on AppException catch (error) {
      state = ExportState(errorMessage: _friendlyError(error));
      return false;
    } catch (_) {
      state = const ExportState(errorMessage: 'PDF export failed.');
      return false;
    }
  }

  String _friendlyError(AppException error) {
    if (error.message.contains('upgrade_required')) {
      return 'upgrade_required';
    }
    return error.message;
  }
}
