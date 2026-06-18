import 'package:my_first_app/core/errors/app_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExportLogRepository {
  const ExportLogRepository(this._client);

  final SupabaseClient _client;

  Future<void> logExportSuccess({
    required String? outputId,
    required String? projectId,
    required String exportType,
    required String fileName,
  }) {
    return _insertLog(
      outputId: outputId,
      projectId: projectId,
      exportType: exportType,
      fileName: fileName,
      status: 'success',
      errorMessage: null,
    );
  }

  Future<void> logExportFailure({
    required String? outputId,
    required String? projectId,
    required String exportType,
    required String fileName,
    required String errorMessage,
  }) {
    return _insertLog(
      outputId: outputId,
      projectId: projectId,
      exportType: exportType,
      fileName: fileName,
      status: 'failed',
      errorMessage: errorMessage,
    );
  }

  Future<List<Map<String, dynamic>>> getUserExportLogs() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw const AppException('You must be logged in.');

      final response = await _client
          .from('export_logs')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return response.cast<Map<String, dynamic>>();
    } on AppException {
      rethrow;
    } on PostgrestException catch (error) {
      throw AppException(error.message);
    } catch (_) {
      throw const AppException('Could not load export logs.');
    }
  }

  Future<void> _insertLog({
    required String? outputId,
    required String? projectId,
    required String exportType,
    required String fileName,
    required String status,
    required String? errorMessage,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return;

      await _client.from('export_logs').insert({
        'user_id': user.id,
        'output_id': outputId,
        'project_id': projectId,
        'export_type': exportType,
        'file_name': fileName,
        'status': status,
        'error_message': errorMessage,
      });
    } catch (_) {
      // Export logs are best-effort and must never break local PDF export.
    }
  }
}
