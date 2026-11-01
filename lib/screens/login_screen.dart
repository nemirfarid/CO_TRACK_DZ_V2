
import 'package:flutter/material.dart';

import '../services/database_service.dart';
import '../services/password_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController company = TextEditingController();
  final TextEditingController user = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirm = TextEditingController();

  bool create = true;
  bool busy = false;
  bool show = false;

  String normalize(String value) {
    final result = value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return result.isEmpty ? 'entreprise' : result;
  }

  void msg(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    company.dispose();
    user.dispose();
    pass.dispose();
    confirm.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (busy) return;

    final name = company.text.trim();
    final username = user.text.trim().toLowerCase();
    final password = pass.text;

    if (name.isEmpty || username.isEmpty || password.length < 8) {
      msg(
        'Renseignez les champs. '
        'Mot de passe : 8 caractères minimum.',
      );
      return;
    }

    if (create && password != confirm.text) {
      msg('Les mots de passe ne correspondent pas.');
      return;
    }

    setState(() => busy = true);

    try {
      final db = DatabaseService.instance;
      String savedName;

      if (create) {
        final salt = PasswordService.salt();

        await db.register(
          name,
          username,
          salt,
          PasswordService.hash(password, salt),
        );

        savedName = name;
      } else {
        final account = await db.account(username);

        if (account == null ||
            !PasswordService.verify(
              password,
              '${account['salt']}',
              '${account['password_hash']}',
            )) {
          throw Exception('Identifiant ou mot de passe incorrect.');
        }

        savedName = '${account['display_name'] ?? username}';
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            enterprise: username,
            company: savedName,
          ),
        ),
      );
    } catch (e) {
      msg(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 88,
                    width: 88,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF075B68),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.sensors,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'CO TRACK DZ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Suivi local des détecteurs de monoxyde de carbone',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Créer entreprise'),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Connexion'),
                      ),
                    ],
                    selected: {create},
                    onSelectionChanged: (selection) {
                      setState(() => create = selection.first);
                    },
                  ),
                  const SizedBox(height: 18),
                  if (create)
                    TextField(
                      controller: company,
                      decoration: const InputDecoration(
                        labelText: 'Nom de l’entreprise',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        user.text = normalize(value);
                      },
                    ),
                  TextField(
                    controller: user,
                    decoration: InputDecoration(
                      labelText: create
                          ? 'Identifiant généré'
                          : 'Identifiant entreprise',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    readOnly: create,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pass,
                    obscureText: !show,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => show = !show);
                        },
                        icon: Icon(
                          show
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  if (create) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirm,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: busy ? null : submit,
                    icon: busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.arrow_forward),
                    label: Text(
                      create
                          ? 'Créer mon espace'
                          : 'Se connecter',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Données conservées uniquement sur cet appareil. '
                    'Aucun serveur ni synchronisation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
