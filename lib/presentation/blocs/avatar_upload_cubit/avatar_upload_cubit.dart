import 'dart:typed_data';
import 'package:audavis_time_management/domain/repositories/colleague_repository.dart';
import 'package:bloc/bloc.dart';
part 'avatar_upload_state.dart';

class AvatarUploadCubit extends Cubit<AvatarUploadState> {
  final ColleagueRepository colleaguesRepository;

  AvatarUploadCubit({required this.colleaguesRepository})
    : super(const AvatarUploadInitial());

  Future<String?> upload({
    required String colleagueId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    emit(const AvatarUploadLoading());
    try {
      final url = await colleaguesRepository.uploadAvatar(
        colleagueId: colleagueId,
        bytes: bytes,
        fileName: fileName,
      );
      emit(AvatarUploadSuccess(url));
      return url;
    } catch (e) {
      emit(AvatarUploadError(e.toString()));
      return null;
    }
  }

  void reset() => emit(const AvatarUploadInitial());
}
