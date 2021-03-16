class ValidateEntries {
  //validation for user inputs to formfields

  String validateUsername(String val) {
    if (val.trim().length < 3 || val.trim().length == 0) {
      return "Enter valid Name";
    } else {
      return null;
    }
  }

  String validateUserAge(String val) {
    if (val.trim().length > 2 ||
        val.trim().length == 0 ||
        (int.parse(val) < 18)) {
      return "Enter Valid age";
    } else {
      return null;
    }
  }

  String validateUserContact(String val) {
    if (val.trim().length != 10 ||
        val.contains(RegExp(r'[^0-9]')) ||
        !val.startsWith('07')) {
      return "Enter valid contact Number";
    } else {
      return null;
    }
  }

  // String validateDeviceSerialNo(String val) {
  //   if ((0 <= val.trim().length && 17 > val.trim().length) ||
  //       val.trim().length > 17) {
  //     return "Enter a valid Serial";
  //   } else {
  //     return null;
  //   }
  // }
}
