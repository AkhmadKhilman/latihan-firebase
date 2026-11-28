import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutter_1/fcm_token_widget.dart';
import 'package:latihan_flutter_1/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const AuthenticationApp(),
    );
  }
}

class AuthenticationApp extends StatelessWidget {
  const AuthenticationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Center(
              child: Text(
                "Mohom Menunggu Sesaat...",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return MyHomePage(title: "Dashboard", user: snapshot.data!);
        }

        return const MyLoginPage();
      },
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessageSystem;
  String _errorMessageUser = "Email atau Password salah";

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessageSystem = null;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login Berhasl"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessageSystem =
              e.message ??
              "Terjadi kesalahan, saat login. Periksa firebase dan jalurnya";
        });

        switch (e.code) {
          case "too-many-requests":
            _errorMessageUser =
                "Terlalu banyak percobaan, Silahkan coba lagi nanti";
          case "user-disabled":
            _errorMessageUser =
                "Akun telah di blokir, silahkan hubungi Customer Service";
        }

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessageUser),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );

        // ignore: unnecessary_brace_in_string_interps, avoid_print
        print("LOGIN GAGAL: ${_errorMessageSystem}");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 30),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: Text("Email"),
                        icon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email harus diisi";
                        }

                        if (!value.contains("@")) {
                          return "Format Email salah";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text("Password"),
                        icon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password harus di isi";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("Login"),
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.user});
  final String title;
  final User user;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout_outlined)),
        ],
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage(user.photoURL!),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "UUID: ${user.uid}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          Divider(),

                          const SizedBox(height: 8),

                          Text(
                            "Nama: ${user.displayName ?? "Display name masih kosong"}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          Divider(),

                          const SizedBox(height: 8),

                          Text(
                            "Email: ${user.email ?? "Email tidak ada"}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          Divider(),

                          const SizedBox(height: 8),

                          Text(
                            "Email Terverifikasi: ${user.emailVerified ? "Ya" : "Tidak"}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          Divider(),

                          const SizedBox(height: 8),

                          Text(
                            "Terakhir Login: ${user.metadata.lastSignInTime.toString()}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          Divider(),
                        ],
                      ),
                    ),
                  ),

                  MyFcmToken(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
