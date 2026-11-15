abstract final class AppConstants {
  static const appName = 'Campus Lost & Found';

  // TODO: Replace with the confirmed campus email domain before release.
  static const allowedEmailDomain = 'campus.edu';

  static const maxPhotosPerItem = 3;
  static const maxPhotoSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const allowedPhotoExtensions = ['jpg', 'jpeg', 'png'];

  static const pageSize = 20;

  static const contactMaskedMessage =
      'Contact details are shared only after a claim is approved.';
}