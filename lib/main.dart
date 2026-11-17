
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

  String? errorMessage;

  void calculateFee() {
  final weight = double.tryParse(weightController.text.trim());
  final rate = double.tryParse(rateController.text.trim());

  // Validate input
  if (weight == null || rate == null || weight < 0 || rate < 0) {
    setState(() {
      errorMessage = 'Please enter valid baggage weight and rate.';
      excessWeight = null;
      excessCharge = null;
      serviceTax = null;
      totalPayable = null;
    });
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
    errorMessage = null;
  });
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedClass,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.airplane_ticket),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Economy',
                  child: Text('Economy (20 kg)'),
                ),
                DropdownMenuItem(
                  value: 'Business',
                  child: Text('Business (40 kg)'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedClass = value;
                  });
                }
              },
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

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

            if (totalPayable != null)
              Card(
                color: const Color(0xFFFFE4EE),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calculation Results',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAD527A),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        'Excess Baggage Weight: ${excessWeight!.toStringAsFixed(2)} kg',
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Excess Baggage Charge: RM ${excessCharge!.toStringAsFixed(2)}',
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Service Tax (8%): RM ${serviceTax!.toStringAsFixed(2)}',
                      ),

                      const Divider(height: 25),

                      Text(
                        'Total Payable: RM ${totalPayable!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAD527A),
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

