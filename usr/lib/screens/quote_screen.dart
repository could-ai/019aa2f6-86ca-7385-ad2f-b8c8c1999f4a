import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final double price = args['price'];
    final String type = args['type'];
    final double value = args['value'];

    final currencyFormat = NumberFormat("#,##0", "fa_IR");

    return Scaffold(
      appBar: AppBar(title: const Text('پیش‌فاکتور بیمه')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                  const SizedBox(height: 24),
                  const Text(
                    'محاسبه با موفقیت انجام شد',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  
                  // Details Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildRow('نوع دستگاه:', type),
                          const Divider(),
                          _buildRow('ارزش اعلام شده:', '${currencyFormat.format(value)} تومان'),
                          const Divider(),
                          _buildRow('پوشش بیمه:', 'کامل (سرقت، شکست، فساد مواد)'),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Text('حق بیمه سالیانه:', style: TextStyle(color: Colors.grey)),
                          Text(
                            '${currencyFormat.format(price)} تومان',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('محاسبه مجدد'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('درخواست شما ثبت شد. کارشناسان ما با شما تماس خواهند گرفت.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('خرید و صدور آنلاین'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
