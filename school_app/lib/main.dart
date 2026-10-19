
import 'package:flutter/material.dart';

void main() {
  runApp(const SchoolApp());
}

class SchoolApp extends StatelessWidget {
  const SchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2457C5),
        ),
        useMaterial3: true,
      ),
      home: const LanguageSelectionPage(),
    );
  }
}

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Color(0xFFE5ECFF),
                      child: Icon(
                        Icons.school_rounded,
                        size: 48,
                        color: Color(0xFF2457C5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'School Management',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose your preferred language',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const WelcomePage(isGujarati: false),
                            ),
                          );
                        },
                        icon: const Icon(Icons.language),
                        label: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'English',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const WelcomePage(isGujarati: true),
                            ),
                          );
                        },
                        icon: const Icon(Icons.translate),
                        label: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'ગુજરાતી',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final bool isGujarati;

  const WelcomePage({super.key, required this.isGujarati});

  @override
  Widget build(BuildContext context) {
    final title = isGujarati ? 'શાળામાં આપનું સ્વાગત છે!' : 'Welcome to School!';
    final message = isGujarati
        ? 'તમારી શાળા વ્યવસ્થાપન એપમાં આપનું સ્વાગત છે.'
        : 'Welcome to your School Management App.';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isGujarati ? 'શાળા વ્યવસ્થાપન' : 'School Management',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.school_rounded,
                size: 80,
                color: Color(0xFF2457C5),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: Text(isGujarati ? 'પાછા જાઓ' : 'Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
