String dateDate(DateTime date) {
  final thisInstant = DateTime.now();
  final diff = thisInstant.difference(date);

  if ((diff.inDays / 365).floor() >= 2) {
    return '${(diff.inDays / 365).floor()} years ago';
  } else if ((diff.inDays / 365).floor() >= 1) {
    return 'Last year';
  } else if ((diff.inDays / 30).floor() >= 2) {
    return '${(diff.inDays / 30).floor()} months ago';
  } else if ((diff.inDays / 30).floor() >= 1) {
    return 'Last month';
  } else if ((diff.inDays / 7).floor() >= 2) {
    return '${(diff.inDays / 7).floor()} weeks ago';
  } else if ((diff.inDays / 7).floor() >= 1) {
    return 'Last week';
  } else if (diff.inDays >= 2) {
    return '${diff.inDays} days ago';
  } else if (diff.inDays >= 1) {
    return 'Yesterday';
  } else if (diff.inHours >= 2) {
    return '${diff.inHours} hours ago';
  } else if (diff.inHours >= 1) {
    return '1 hour ago';
  } else if (diff.inMinutes >= 2) {
    return '${diff.inMinutes} minutes ago';
  } else if (diff.inMinutes >= 1) {
    return '1 minute ago';
  } else if (diff.inSeconds >= 3) {
    return '${diff.inSeconds} seconds ago';
  } else {
    return 'Just now';
  }
}
