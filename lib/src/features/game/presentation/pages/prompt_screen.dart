import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_flip/src/features/game/presentation/bloc/prompt_cubit.dart';
import 'package:pixel_flip/src/features/game/presentation/widgets/primary_button.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    // Check connectivity status when the screen loads
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    // TODO: Implement connectivity check
    setState(() {
      _isOffline = false; // Update this based on actual connectivity
    });
  }

  void _startGame() {
    if (_formKey.currentState?.validate() ?? false) {
      final searchTerm = _searchController.text.trim();
      // TODO: Navigate to game screen with search term
    }
  }

  void _startOfflineGame() {
    // TODO: Navigate to offline game screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Flip'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(
                  Icons.photo_library_outlined,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                Text(
                  'Enter a theme to start the game',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Theme (e.g., cats, beach, space)',
                    prefixIcon: Icon(Icons.search),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a theme';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  onPressed: _startGame,
                  label: 'Start Game',
                  icon: Icons.play_arrow,
                ),
                if (_isOffline) ...[
                  const SizedBox(height: 16),
                  const Text('OR'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _startOfflineGame,
                    child: const Text('Play Offline'),
                  ),
                ],
                const Spacer(),
                Text(
                  'Powered by Pixabay',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
