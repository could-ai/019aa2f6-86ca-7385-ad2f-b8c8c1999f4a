import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Values
  String? _fridgeType;
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _hasUps = false;

  // Dropdown Options
  final List<Map<String, dynamic>> _fridgeTypes = [
    {'label': 'یخچال ایستاده تک درب', 'value': 'single_door', 'risk_factor': 1.0},
    {'label': 'یخچال ایستاده دو درب', 'value': 'double_door', 'risk_factor': 1.2},
    {'label': 'یخچال پرده هوا (بدون درب)', 'value': 'open_air', 'risk_factor': 1.5},
    {'label': 'فریزر صندوقی', 'value': 'chest_freezer', 'risk_factor': 1.1},
    {'label': 'سردخانه walk-in', 'value': 'walk_in', 'risk_factor': 2.0},
  ];

  // Helper to convert Persian digits to English
  String _replaceFarsiNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(farsi[i], english[i]);
    }
    return input;
  }

  void _calculateAndGo() {
    if (_formKey.currentState!.validate()) {
      // Logic for calculation
      double baseRate = 500000; // Base price in Tomans
      
      // Clean inputs (remove commas, convert Persian digits)
      String cleanValue = _replaceFarsiNumber(_valueController.text).replaceAll(',', '');
      String cleanAge = _replaceFarsiNumber(_ageController.text);

      double value = double.parse(cleanValue);
      int age = int.parse(cleanAge);
      
      // Find risk factor
      var selectedType = _fridgeTypes.firstWhere((e) => e['value'] == _fridgeType);
      double typeFactor = selectedType['risk_factor'];
      
      // Age factor (older = more expensive)
      double ageFactor = 1 + (age * 0.05);
      
      // Value factor (1% of declared value)
      double valueFactor = value * 0.01;
      
      // Calculate total
      double totalPremium = (baseRate * typeFactor * ageFactor) + valueFactor;
      
      // Discount for UPS (Protector)
      if (_hasUps) {
        totalPremium *= 0.9; // 10% discount
      }

      Navigator.pushNamed(
        context, 
        '/quote', 
        arguments: {
          'price': totalPremium,
          'type': selectedType['label'],
          'value': value,
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محاسبه حق بیمه'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مشخصات دستگاه',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Fridge Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'نوع یخچال',
                  prefixIcon: Icon(Icons.kitchen),
                ),
                value: _fridgeType,
                items: _fridgeTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['value'],
                    child: Text(type['label']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _fridgeType = value),
                validator: (value) => value == null ? 'لطفا نوع یخچال را انتخاب کنید' : null,
              ),
              const SizedBox(height: 16),

              // Value Input
              TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ارزش تقریبی دستگاه (تومان)',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: 'تومان',
                  hintText: 'مثلا: ۵۰,۰۰۰,۰۰۰',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'لطفا ارزش دستگاه را وارد کنید';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age Input
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'سن دستگاه (سال)',
                  prefixIcon: Icon(Icons.history),
                  hintText: 'مثلا: ۲',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'لطفا سن دستگاه را وارد کنید';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // UPS Checkbox
              SwitchListTile(
                title: const Text('آیا دستگاه دارای محافظ برق/UPS است؟'),
                subtitle: const Text('۱۰٪ تخفیف برای دستگاه‌های دارای محافظ'),
                value: _hasUps,
                onChanged: (val) => setState(() => _hasUps = val),
                secondary: const Icon(Icons.power),
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateAndGo,
                  child: const Text(
                    'محاسبه قیمت',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
