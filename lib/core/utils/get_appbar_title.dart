String getAppBarTitle({required int currentIndex}) {
  switch (currentIndex) {
    case 0:
      return "ChatBox";
    case 1:
      return "Groups";
    case 2:
      return "Status";
    case 3:
      return "Calls";
    default:
      return '';
  }
}