import 'package:flutter/material.dart';
import 'api_service.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _controller = TextEditingController();
  String _fromCurrency = 'usd';
  String _toCurrency = 'inr';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  Map<String, double> _rates = {};
  List<String> _currencies = [];

  @override
  void initState() {
    super.initState();
    _loadRates(_fromCurrency);
  }

  Future<void> _loadRates(String currencyCode) async {
    setState(() => _isLoading = true);

    final rates = await ApiService.fetchRates(currencyCode);

    if (rates == null || rates.isEmpty) {
      _showError("Failed to load $currencyCode rates");
    } else {
      setState(() {
        _rates = rates;
        _currencies = rates.keys.toList()..sort();
      });
    }

    setState(() => _isLoading = false);
  }

  void _convertCurrency() {
    if (_rates.isEmpty) {
      _showError("Rates not loaded yet");
      return;
    }

    try {
      final amount = double.parse(_controller.text);
      final result = ApiService.convertCurrency(
        amount: amount,
        from: _fromCurrency,
        to: _toCurrency,
        rates: _rates,
      );

      setState(() => _convertedAmount = result);
    } catch (e) {
      _showError("Invalid input! Enter numbers only");
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _loadRates(_fromCurrency);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/currency.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _convertedAmount.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: screenWidth > 400 ? 400 : screenWidth * 0.9,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                value: _fromCurrency,
                                dropdownColor: Colors.grey[900],
                                style: const TextStyle(color: Colors.white),
                                iconEnabledColor: Colors.white,
                                underline: const SizedBox(),
                                onChanged: (value) {
                                  setState(() {
                                    _fromCurrency = value!;
                                    _loadRates(value);
                                  });
                                },
                                items: _currencies.map((code) {
                                  return DropdownMenuItem(
                                    value: code,
                                    child: Text(code.toUpperCase()),
                                  );
                                }).toList(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.swap_horiz,
                                  color: Colors.white),
                              onPressed: _swapCurrencies,
                            ),
                            Expanded(
                              child: DropdownButton<String>(
                                value: _toCurrency,
                                dropdownColor: Colors.grey[900],
                                style: const TextStyle(color: Colors.white),
                                iconEnabledColor: Colors.white,
                                underline: const SizedBox(),
                                onChanged: (value) {
                                  setState(() => _toCurrency = value!);
                                },
                                items: _currencies.map((code) {
                                  return DropdownMenuItem(
                                    value: code,
                                    child: Text(code.toUpperCase()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Amount',
                            prefixIcon: const Icon(Icons.monetization_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _convertCurrency,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Convert'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'api_service.dart';
//
// class CurrencyConverter extends StatefulWidget {
//   const CurrencyConverter({super.key});
//
//   @override
//   _CurrencyConverterState createState() => _CurrencyConverterState();
// }
//
// class _CurrencyConverterState extends State<CurrencyConverter> {
//   final TextEditingController _controller = TextEditingController();
//   String _fromCurrency = 'usd';
//   String _toCurrency = 'inr';
//   double _convertedAmount = 0.0;
//   bool _isLoading = false;
//   Map<String, double> _rates = {};
//   List<String> _currencies = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRates(_fromCurrency);
//   }
//
//   Future<void> _loadRates(String currencyCode) async {
//     setState(() => _isLoading = true);
//
//     final rates = await ApiService.fetchRates(currencyCode);
//
//     if (rates == null || rates.isEmpty) {
//       _showError("Failed to load $currencyCode rates");
//     } else {
//       setState(() {
//         _rates = rates;
//         _currencies = rates.keys.toList()..sort();
//         // If the currently selected _toCurrency is not in the list, reset it
//         if (!_currencies.contains(_toCurrency)) {
//           _toCurrency = _currencies.first;
//         }
//       });
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   void _convertCurrency() {
//     if (_rates.isEmpty) {
//       _showError("Rates not loaded yet");
//       return;
//     }
//
//     try {
//       final amount = double.parse(_controller.text);
//       final result = ApiService.convertCurrency(
//         amount: amount,
//         from: _fromCurrency,
//         to: _toCurrency,
//         rates: _rates,
//       );
//
//       setState(() => _convertedAmount = result);
//     } catch (e) {
//       _showError("Invalid input! Enter numbers only");
//     }
//   }
//
//   void _swapCurrencies() {
//     setState(() {
//       final temp = _fromCurrency;
//       _fromCurrency = _toCurrency;
//       _toCurrency = temp;
//       _loadRates(_fromCurrency);
//     });
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/currency.webp',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned.fill(
//             child: Container(color: Colors.black.withOpacity(0.6)),
//           ),
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _convertedAmount.toStringAsFixed(2),
//                     style: const TextStyle(
//                       fontSize: 40,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Container(
//                     width: screenWidth > 400 ? 400 : screenWidth * 0.9,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: DropdownButton<String>(
//                                 value: _fromCurrency,
//                                 dropdownColor: Colors.grey[900],
//                                 style: const TextStyle(color: Colors.white),
//                                 iconEnabledColor: Colors.white,
//                                 underline: const SizedBox(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _fromCurrency = value!;
//                                     _loadRates(value);
//                                   });
//                                 },
//                                 items: _currencies.map((code) {
//                                   return DropdownMenuItem(
//                                     value: code,
//                                     child: Text(code.toUpperCase()),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.swap_horiz,
//                                   color: Colors.white),
//                               onPressed: _swapCurrencies,
//                             ),
//                             Expanded(
//                               child: DropdownButton<String>(
//                                 value: _toCurrency,
//                                 dropdownColor: Colors.grey[900],
//                                 style: const TextStyle(color: Colors.white),
//                                 iconEnabledColor: Colors.white,
//                                 underline: const SizedBox(),
//                                 onChanged: (value) {
//                                   setState(() => _toCurrency = value!);
//                                 },
//                                 items: _currencies.map((code) {
//                                   return DropdownMenuItem(
//                                     value: code,
//                                     child: Text(code.toUpperCase()),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         TextField(
//                           controller: _controller,
//                           style: const TextStyle(color: Colors.black),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Enter Amount',
//                             prefixIcon: const Icon(Icons.monetization_on),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: _convertCurrency,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.black,
//                             minimumSize: const Size(double.infinity, 50),
//                           ),
//                           child: const Text('Convert'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (_isLoading) const Center(child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }
// }


