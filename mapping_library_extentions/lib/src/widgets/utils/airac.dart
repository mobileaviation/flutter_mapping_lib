class Airac {
  static final DateTime _epoch = DateTime(1901, 1, 10);

  static String getCurrentAiracCycle() {
    return _getAiracCycle(DateTime.now());
  }

  static String getAiracCycleByDateTime(DateTime dateTime) {
    return _getAiracCycle(dateTime);
  }

  static String _getAiracCycle(DateTime dateTime) {
    num cyclesTotal = ((dateTime.difference(_epoch).inDays + 1) / 28);
    num cyclesUntilStartThisYear =
        (new DateTime(dateTime.year).difference(_epoch).inDays / 28).floor();
    num cyclesThisYear = cyclesTotal - cyclesUntilStartThisYear;

    num year = dateTime.year;

    String cyclesThisYearS = cyclesThisYear.floor().toString();
    cyclesThisYearS = (cyclesThisYearS.length == 1)
        ? cyclesThisYearS.padLeft(2, "0")
        : cyclesThisYearS;

    return year.floor().toString().substring(2) + cyclesThisYearS;
  }
}
