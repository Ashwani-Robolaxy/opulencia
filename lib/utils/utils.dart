import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String currencyConvert({required double price}) {
    // Create a NumberFormat with the appropriate pattern and locale
    NumberFormat format =
        NumberFormat.currency(locale: 'de_DE', symbol: '', decimalDigits: 2);

    // Format the price
    String formattedPrice = format.format(price);
    print(formattedPrice); // Output: 1.223.456.789,14
    return formattedPrice;
  }
}
