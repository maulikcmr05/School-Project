import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SchoolManagementApp());
}

class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3157D5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const LanguagePage(),
    );
  }
}

class AppLanguage {
  static String current = 'en';

  static String text(String english, String gujarati) {
    return current == 'gu' ? gujarati : english;
  }
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  void _openLogin(BuildContext context, String language) {
    AppLanguage.current = language;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.school_rounded,
                      size: 76,
                      color: Color(0xFF3157D5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'School Management',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'શાળા વ્યવસ્થાપન એપ્લિકેશન',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Choose your language / ભાષા પસંદ કરો',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.language),
                        label: const Text('English'),
                        onPressed: () => _openLogin(context, 'en'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.translate),
                        label: const Text('ગુજરાતી'),
                        onPressed: () => _openLogin(context, 'gu'),
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _authErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AppLanguage.text(
          'Please enter a valid email address.',
          'યોગ્ય ઈમેલ એડ્રેસ દાખલ કરો.',
        );
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return AppLanguage.text(
          'Incorrect email or password.',
          'ઈમેલ અથવા પાસવર્ડ ખોટો છે.',
        );
      case 'too-many-requests':
        return AppLanguage.text(
          'Too many attempts. Try again later.',
          'ઘણા પ્રયત્નો થયા છે. થોડી વાર પછી પ્રયાસ કરો.',
        );
      case 'network-request-failed':
        return AppLanguage.text(
          'Network error. Check your internet connection.',
          'નેટવર્કની સમસ્યા છે. ઈન્ટરનેટ ચેક કરો.',
        );
      case 'operation-not-allowed':
        return AppLanguage.text(
          'Email/password login is not enabled in Firebase.',
          'Firebase માં Email/Password login ચાલુ નથી.',
        );
      default:
        return AppLanguage.text(
          'Login failed. Please check your Firebase settings.',
          'લોગિન થયું નથી. Firebase settings ચેક કરો.',
        );
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Firebase did not return a user.');
      }

      final profile = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = profile.data();
      final role = (data?['role'] as String?)?.toLowerCase().trim();

      // A valid profile must exist. The role is read from Firestore,
      // never selected by the person logging in.
      const allowedRoles = {'admin', 'teacher', 'student', 'parent'};
      if (!profile.exists || role == null || !allowedRoles.contains(role)) {
        await FirebaseAuth.instance.signOut();
        _showMessage(
          AppLanguage.text(
            'Your account has no valid school profile. Contact the school administrator.',
            'તમારા એકાઉન્ટની શાળા પ્રોફાઇલ યોગ્ય નથી. શાળા એડમિનનો સંપર્ક કરો.',
          ),
        );
        return;
      }

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(
            userId: user.uid,
            role: role,
          ),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(_authErrorMessage(e));
    } on FirebaseException catch (e) {
      // If the profile read is denied or Firestore is unavailable, do not
      // leave the user signed in without a verified role.
      await FirebaseAuth.instance.signOut();
      _showMessage(
        AppLanguage.text(
          'Could not verify your school profile (${e.code}). Check Firestore Rules and try again.',
          'શાળા પ્રોફાઇલ ચકાસી શકાઈ નથી (${e.code}). Firestore Rules ચેક કરીને ફરી પ્રયાસ કરો.',
        ),
      );
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      _showMessage(
        AppLanguage.text(
          'Something went wrong. Please try again.',
          'કંઈક ખોટું થયું. ફરી પ્રયાસ કરો.',
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGujarati = AppLanguage.current == 'gu';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text('School Management', 'શાળા વ્યવસ્થાપન'),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading
                ? null
                : () => setState(
                      () => AppLanguage.current = isGujarati ? 'en' : 'gu',
                    ),
            child: Text(isGujarati ? 'English' : 'ગુજરાતી'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.account_circle_rounded,
                        size: 70,
                        color: Color(0xFF3157D5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLanguage.text('Login', 'લોગિન'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLanguage.text(
                          'Sign in with an account created by the school administrator.',
                          'શાળા એડમિન દ્વારા બનાવેલા એકાઉન્ટથી લોગિન કરો.',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username],
                        decoration: InputDecoration(
                          labelText: AppLanguage.text('Email Address', 'ઈમેલ એડ્રેસ'),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(value.trim())) {
                            return AppLanguage.text(
                              'Enter a valid email.',
                              'યોગ્ય ઈમેલ દાખલ કરો.',
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: AppLanguage.text('Password', 'પાસવર્ડ'),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _hidePassword = !_hidePassword,
                            ),
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLanguage.text(
                              'Enter your password.',
                              'પાસવર્ડ દાખલ કરો.',
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(AppLanguage.text('Login', 'લોગિન કરો')),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLanguage.text(
                          'No public registration. Ask the school administrator for an account.',
                          'જાહેર રજિસ્ટ્રેશન બંધ છે. એકાઉન્ટ માટે શાળા એડમિનનો સંપર્ક કરો.',
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardFeature {
  final String english;
  final String gujarati;
  final IconData icon;

  const _DashboardFeature(this.english, this.gujarati, this.icon);
}

class DashboardPage extends StatelessWidget {
  final String userId;
  final String role;

  const DashboardPage({
    super.key,
    required this.userId,
    required this.role,
  });

  static const List<_DashboardFeature> _features = [
    _DashboardFeature('Students', 'વિદ્યાર્થીઓ', Icons.people_alt),
    _DashboardFeature('Teachers', 'શિક્ષકો', Icons.co_present),
    _DashboardFeature('Attendance', 'હાજરી', Icons.fact_check),
    _DashboardFeature('Homework', 'હોમવર્ક', Icons.menu_book),
    _DashboardFeature('Timetable', 'સમયપત્રક', Icons.calendar_month),
    _DashboardFeature('Notices', 'નોટિસ', Icons.campaign),
    _DashboardFeature('Results', 'પરિણામ', Icons.bar_chart),
  ];

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.text('School Dashboard', 'શાળા ડેશબોર્ડ')),
        actions: [
          IconButton(
            tooltip: AppLanguage.text('Logout', 'લોગઆઉટ'),
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AppLanguage.text(
                    'Could not load your profile. Check Firestore Rules.',
                    'પ્રોફાઇલ લોડ થઈ નથી. Firestore Rules ચેક કરો.',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data?.data();
          final currentRole = (profile?['role'] as String?)?.toLowerCase().trim();

          if (profile == null || currentRole != role) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AppLanguage.text(
                    'Your profile is missing or has changed. Please log out and contact the administrator.',
                    'તમારી પ્રોફાઇલ નથી અથવા બદલાઈ છે. લોગઆઉટ કરીને એડમિનનો સંપર્ક કરો.',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final name = profile['name'] as String? ??
              FirebaseAuth.instance.currentUser?.email ??
              'User';
          final isAdmin = currentRole == 'admin';

          final visibleFeatures = isAdmin
              ? _features
              : _features.where((f) => f.english == 'Notices' ||
                  f.english == 'Homework' ||
                  f.english == 'Timetable' ||
                  f.english == 'Attendance' ||
                  f.english == 'Results').toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3157D5), Color(0xFF6687F1)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.school, color: Colors.white, size: 42),
                      const SizedBox(height: 16),
                      Text(
                        AppLanguage.text('Welcome, $name!', 'સ્વાગત છે, $name!'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppLanguage.text('Role', 'રોલ')}: ${_displayRole(currentRole!)}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        FirebaseAuth.instance.currentUser?.email ?? '',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  AppLanguage.text('School Features', 'શાળાની સુવિધાઓ'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 650 ? 3 : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: visibleFeatures.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.15,
                      ),
                      itemBuilder: (context, index) {
                        final feature = visibleFeatures[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FeaturePage(feature: feature),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    feature.icon,
                                    size: 38,
                                    color: const Color(0xFF3157D5),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    AppLanguage.text(
                                      feature.english,
                                      feature.gujarati,
                                    ),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  AppLanguage.text(
                    'Note: These feature pages are placeholders; their data-entry and management functions will be added next.',
                    'નોંધ: આ સુવિધાઓના પેજ હાલ પ્રારંભિક છે; ડેટા ઉમેરવા અને મેનેજ કરવાની સુવિધા આગળ ઉમેરવામાં આવશે.',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _displayRole(String role) {
    switch (role) {
      case 'admin':
        return AppLanguage.text('Admin', 'એડમિન');
      case 'teacher':
        return AppLanguage.text('Teacher', 'શિક્ષક');
      case 'student':
        return AppLanguage.text('Student', 'વિદ્યાર્થી');
      case 'parent':
        return AppLanguage.text('Parent', 'વાલી');
      default:
        return role;
    }
  }
}

class FeaturePage extends StatelessWidget {
  final _DashboardFeature feature;

  const FeaturePage({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.text(feature.english, feature.gujarati)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature.icon, size: 80, color: const Color(0xFF3157D5)),
              const SizedBox(height: 20),
              Text(
                AppLanguage.text(feature.english, feature.gujarati),
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                AppLanguage.text(
                  'This section is a placeholder. Its functions will be built next.',
                  'આ વિભાગ હાલ પ્રારંભિક છે. તેની સુવિધાઓ આગળ બનાવવામાં આવશે.',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: Text(AppLanguage.text('Back to Dashboard', 'ડેશબોર્ડ પર પાછા જાઓ')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
