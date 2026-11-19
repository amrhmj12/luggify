
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const LuggifyApp());
}

class LuggifyApp extends StatelessWidget {
  const LuggifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luggify',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD66B9A),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController weightController =
      TextEditingController();

  final TextEditingController rateController =
      TextEditingController();

  String selectedClass = 'Economy';

  double? excessWeight;
  double? excessCharge;
  double? serviceTax;
  double? totalPayable;

  void calculateFee() {
  final weight = double.tryParse(weightController.text.trim());
  final rate = double.tryParse(rateController.text.trim());

  // Validate input
 
if (weight == null || rate == null || weight < 0 || rate < 0 || weight > 50) {
  setState(() {
    excessWeight = null;
    excessCharge = null;
    serviceTax = null;
    totalPayable = null;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        'Invalid input! Baggage weight must be between 0 and 50 kg, and rate cannot be negative.',
      ),
      backgroundColor: const Color(0xFF704858),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  return;
}

  // Determine baggage allowance
  final allowance = selectedClass == 'Economy' ? 20.0 : 40.0;

  // Calculate excess baggage
  final excess = weight > allowance ? weight - allowance : 0.0;

  // Calculate charges
  final charge = excess * rate;
  final tax = charge * 0.08;
  final total = charge + tax;

  setState(() {
    excessWeight = excess;
    excessCharge = charge;
    serviceTax = tax;
    totalPayable = total;
  });
}


Widget _resultRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF70636A),
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF51464B),
          ),
        ),
      ],
    ),
  );
}

  @override
  void dispose() {
    weightController.dispose();
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE4EE),
        title: const Text(
          'Luggify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFAD527A),
          ),
        ),
        centerTitle: true,
      ),

            drawer: Drawer(
        backgroundColor: const Color(0xFFFFF7FA),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFFFE4EE),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.luggage,
                    size: 45,
                    color: Color(0xFFAD527A),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Luggify',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAD527A),
                    ),
                  ),
                  Text(
                    'Your baggage fee calculator',
                    style: TextStyle(
                      color: Colors.pink.shade700,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                // About page will be added next
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Welcome to Luggify!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAD527A),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Calculate your excess baggage fee easily.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // Baggage Weight
            const Text(
              'Baggage Weight (kg)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter baggage weight',
                prefixIcon: const Icon(Icons.scale),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            
            // Ticket Class
            const Text(
              'Ticket Class',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF704858),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                ChoiceChip(
                  avatar: const Icon(Icons.flight_class, size: 18),
                  label: const Text('Economy (20 kg)'),
                  selected: selectedClass == 'Economy',
                  selectedColor: const Color(0xFFD66B91),
                  backgroundColor: const Color(0xFFF5E3E9),
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: selectedClass == 'Economy'
                        ? Colors.white
                        : const Color(0xFF704858),
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedClass = 'Economy';
                    });
                  },
                ),

                ChoiceChip(
                  avatar: const Icon(Icons.flight, size: 18),
                  label: const Text('Business (40 kg)'),
                  selected: selectedClass == 'Business',
                  selectedColor: const Color(0xFFD66B91),
                  backgroundColor: const Color(0xFFF5E3E9),
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: selectedClass == 'Business'
                        ? Colors.white
                        : const Color(0xFF704858),
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedClass = 'Business';
                    });
                  },
                ),
              ],
            ),



            const SizedBox(height: 20),

            // Excess Baggage Rate
            const Text(
              'Excess Baggage Rate (RM/kg)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter rate per kg',
                prefixIcon: const Icon(Icons.payments_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
                        const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: calculateFee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD66B9A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Calculate Fee',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            if (totalPayable != null)
              Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: Color(0xFFD66B91),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Calculation Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF704858),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _resultRow(
                        'Excess Baggage Weight',
                        '${excessWeight!.toStringAsFixed(2)} kg',
                      ),

                      _resultRow(
                        'Excess Baggage Charge',
                        'RM ${excessCharge!.toStringAsFixed(2)}',
                      ),

                      _resultRow(
                        'Service Tax (8%)',
                        'RM ${serviceTax!.toStringAsFixed(2)}',
                      ),

                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E3E9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL PAYABLE',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF704858),
                                letterSpacing: 1,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'RM ${totalPayable!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD66B91),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _openGitHub() async {
    final Uri url = Uri.parse('https://github.com/amrhmj12/luggify');

    if (!await launchUrl(url)) {
      throw Exception('Could not open GitHub repository');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FA),
      appBar: AppBar(
        title: const Text(
          'About Luggify',
          style: TextStyle(
            color: Color(0xFFAD527A),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFE4EE),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFFFFE4EE),
                child: Icon(
                  Icons.luggage,
                  size: 60,
                  color: Color(0xFFAD527A),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Luggify',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAD527A),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your Baggage Fee Calculator',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Author Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAD527A),
                        ),
                      ),

                      SizedBox(height: 20),

                      Text('Name:'),
                      Text(
                        'Amirah Binti Mohd Jais',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 15),

                      Text('Matric Number:'),
                      Text(
                        '2025430032',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 15),

                      Text('Course:'),
                      Text(
                        'Bachelor of Computer Science (Hons.) Netcentric Computing',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(
                    Icons.code,
                    color: Color(0xFFAD527A),
                    size: 30,
                  ),
                  title: const Text(
                    'GitHub Repository',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAD527A),
                    ),
                  ),
                  subtitle: const Text(
                    'View Luggify source code',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.open_in_new,
                    color: Color(0xFFAD527A),
                  ),
                  onTap: _openGitHub,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                '© 2026 Luggify. All Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

