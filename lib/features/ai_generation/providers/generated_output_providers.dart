import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/core/errors/app_exception.dart';
import 'package:my_first_app/features/ai_generation/models/generated_output_model.dart';
import 'package:my_first_app/features/auth/providers/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final generatedOutputByIdProvider =
    FutureProvider.family<GeneratedOutputModel?, String>((ref, outputId) async {
      final client = ref.watch(supabaseClientProvider);
      try {
        final response = await client
            .from('generated_outputs')
            .select('*, app_projects(title, name)')
            .eq('id', outputId)
            .maybeSingle();

        if (response == null) return null;
        return GeneratedOutputModel.fromJson(response);
      } on PostgrestException catch (error) {
        throw AppException(error.message);
      } catch (_) {
        throw const AppException('Could not load generated output.');
      }
    });
