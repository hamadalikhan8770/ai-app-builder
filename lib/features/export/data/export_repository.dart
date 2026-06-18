import 'dart:io';
import 'dart:typed_data';

import 'package:my_first_app/core/errors/app_exception.dart';
import 'package:my_first_app/features/ai_generation/models/generated_output_model.dart';
import 'package:my_first_app/features/export/data/export_log_repository.dart';
import 'package:my_first_app/features/export/data/pdf_export_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExportRepository {
  const ExportRepository({
    required this.client,
    required this.pdfExportService,
    required this.exportLogRepository,
  });

  final SupabaseClient client;
  final PdfExportService pdfExportService;
  final ExportLogRepository exportLogRepository;

  Future<bool> checkExportPermission() async {
    final user = client.auth.currentUser;
    if (user == null) throw const AppException('You must be logged in.');

    final profile = await client
        .from('profiles')
        .select('role, subscription_tier, is_disabled, is_blocked')
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) return false;
    if (profile['is_disabled'] == true || profile['is_blocked'] == true) {
      throw const AppException('Your account is disabled.');
    }

    final role = profile['role']?.toString() ?? 'free_user';
    final tier = profile['subscription_tier']?.toString() ?? 'free';
    return role == 'admin' || role == 'premium_user' || tier == 'premium';
  }

  Future<Uint8List> buildPdfForOutput(GeneratedOutputModel output) async {
    await _requirePremiumExport();
    return pdfExportService.buildGeneratedOutputPdf(output);
  }

  Future<void> previewOutputPdf(GeneratedOutputModel output) async {
    final fileName = pdfExportService.buildFileName(output);
    try {
      final bytes = await buildPdfForOutput(output);
      await pdfExportService.previewPdf(output: output, bytes: bytes);
      await exportLogRepository.logExportSuccess(
        outputId: output.id,
        projectId: output.projectId,
        exportType: 'pdf_preview',
        fileName: fileName,
      );
    } catch (error) {
      await exportLogRepository.logExportFailure(
        outputId: output.id,
        projectId: output.projectId,
        exportType: 'pdf_preview',
        fileName: fileName,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> shareOutputPdf(GeneratedOutputModel output) async {
    final fileName = pdfExportService.buildFileName(output);
    try {
      final bytes = await buildPdfForOutput(output);
      await pdfExportService.sharePdf(output: output, bytes: bytes);
      await exportLogRepository.logExportSuccess(
        outputId: output.id,
        projectId: output.projectId,
        exportType: 'pdf_share',
        fileName: fileName,
      );
    } catch (error) {
      await exportLogRepository.logExportFailure(
        outputId: output.id,
        projectId: output.projectId,
        exportType: 'pdf_share',
        fileName: fileName,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<File> saveOutputPdf(GeneratedOutputModel output) async {
    final fileName = pdfExportService.buildFileName(output);
    try {
      final bytes = await buildPdfForOutput(output);
      final file = await pdfExportService.savePdfToDevice(
        output: output,
        bytes: bytes,
      );
      await exportLogRepository.logExportSuccess(
        outputId: output.id,
        projectId: output.projectId,
        exportType: 'pdf_save',
        fileName: fileName,
      );
      return file;
    } catch (error) {
      await exportLogRepository.logExportFailure(
        outputId: output.id,
        projectId: output.projectId,
        exportType: 'pdf_save',
        fileName: fileName,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> _requirePremiumExport() async {
    final allowed = await checkExportPermission();
    if (!allowed) {
      throw const AppException(
        'upgrade_required: PDF export is available for Premium users.',
      );
    }
  }
}
