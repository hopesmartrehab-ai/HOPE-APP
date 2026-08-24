abstract class PhoneHelper {
  static String formatEgyptianPhoneForApi(String phone) {
    return '+20${phone.trim()}';
  }
}
