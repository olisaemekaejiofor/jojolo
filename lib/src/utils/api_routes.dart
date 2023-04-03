class AppUrl {
  static const String baseUrl = 'https://backend.jojoloapp.com/api/v1';
  static const String caregiver = baseUrl + '/caregiver';
  static const String doctor = baseUrl + '/doctor';

  static const String caregiverRegister = caregiver + '/create-account';
  static const String doctorRegister = doctor + '/register-doctor';

  static const String caregiverLogin = caregiver + '/sign-in';
  static const String doctorLogin = doctor + '/login-doctor';

//caregiver routes
  static const String sendCode = caregiver + '/search-account';
  static const String verifyCode = caregiver + '/validate-code';
  static const String resetPassword = caregiver + '/forgot-password';
  static const String getFeeds = caregiver + '/share-posts';
  static const String getPost = caregiver + '/posts';
  static const String getMyPosts = caregiver + '/posts?caregiverId=';
  static const String getSavedPosts = caregiver + '/saved-post/';
  static const String getTags = caregiver + '/tags';
  static const String savePost = caregiver + '/change-post-status/';
  static const String search = caregiver + '/search-tags/';
  static const String createPost = caregiver + '/create-post';
  static const String caregiverLike = caregiver + '/post-like';
  static const String filterPopular = caregiver + '/filter-popular';
  static const String deletePost = caregiver + '/post/';
  static const String commentPost = caregiver + '/comment-post';
  static const String commentReply = caregiver + '/comment-reply';
  static const String getUpcoming = caregiver + '/bookings?caregiverId=';
  static const String reportPost = caregiver + '/report-post';

//doctor routes
  static const String sendDCode = doctor + '/code-input';
  static const String verifyDCode = doctor + '/verify-code';
  static const String resetDPassword = doctor + '/forgot-password';
  static const String getDFeeds = doctor + '/posts';
  static const String doctorLike = doctor + '/post-like';
  static const String getDoctorPost = doctor + '/posts?doctorId=';
  static const String getDSavedPosts = doctor + '/saved-post/';
  static const String getDTags = doctor + '/tags';
  static const String dSearch = doctor + '/search-tags/';
  static const String saveDPost = doctor + '/change-post-status/';
  static const String updateLicense = doctor + '/profile-medical-license/';
  static const String updateId = doctor + '/profile-valid-card/';
  static const String dPost = doctor + '/doctor-post';
  static const String filterPopularD = doctor + '/filter-popular';
  static const String deleteDPost = doctor + '/post/';
  static const String dCommentPost = doctor + '/comment-post';
  static const String dCommentReply = doctor + '/comment-reply';
  static const String reportDPost = doctor + '/report-post';
  static const String getPending = doctor + '/doctor-bookings?doctorId=';
  static const String getdUpcoming = doctor + '/doctor-bookings?doctorId=';
  static const String paymentHistory = doctor + '/payment-notice?doctorId=';
  static const String withdrawRequest = doctor + '/payment/withdrawal-request';
  static const String getMonthlyEarning = doctor + '/earnings/monthly-earning';
}
