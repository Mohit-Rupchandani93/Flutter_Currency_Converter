
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, double>?> fetchRates(String currencyCode) async {
    final url =
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/${currencyCode.toLowerCase()}.json';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
          'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 Chrome/98.0.4758.102 Mobile Safari/537.36',
        },
      ).timeout(const Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Map<String, double>.from(jsonData[currencyCode.toLowerCase()]);
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print("Fetch error: $e");
      return null;
    }
  }

  static double convertCurrency({
    required double amount,
    required String from,
    required String to,
    required Map<String, double> rates,
  }) {
    if (from == to) return amount;
    if (!rates.containsKey(from) || !rates.containsKey(to)) return 0.0;

    return amount * (rates[to]! / rates[from]!);
  }
}
