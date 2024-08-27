class DateTimeFormatter {

  static String remainDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inSeconds < 60) {
      return '잠시 후';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 후';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 후';
    } else {
      return '${difference.inDays}일 후';
    }
  }


}