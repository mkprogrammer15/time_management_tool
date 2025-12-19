part of 'avatar_upload_cubit.dart';

sealed class AvatarUploadState {
  const AvatarUploadState();
}

class AvatarUploadInitial extends AvatarUploadState {
  const AvatarUploadInitial();
}

class AvatarUploadLoading extends AvatarUploadState {
  const AvatarUploadLoading();
}

class AvatarUploadSuccess extends AvatarUploadState {
  final String url;
  const AvatarUploadSuccess(this.url);
}

class AvatarUploadError extends AvatarUploadState {
  final String message;
  const AvatarUploadError(this.message);
}
