import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_flip/src/core/widgets/primary_button.dart';
import 'package:pixel_flip/src/features/game/presentation/game/game_screen.dart';
import 'package:pixel_flip/src/features/game/presentation/prompt/bloc/prompt_cubit.dart';

import '../../../../../l10n/app_localizations.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check connectivity status when the screen loads
  }

  void _startGame() {
    if (_formKey.currentState?.validate() ?? false) {
      final searchTerm = _searchController.text.trim();
      context.read<PromptCubit>().searchImages(searchTerm);
    }
  }

  void _startOfflineGame() {
    // Navigate to game screen with offline mode
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GameScreen(
          isOfflineMode: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PromptCubit, PromptState>(
      listener: (context, state) {
        if (state is PromptError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is PromptLoaded && state.imageUrls.isNotEmpty) {
          // Navigate to game screen with the fetched images
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(
                imageUrls: state.imageUrls,
                isOfflineMode: false,
              ),
            ),
          );
        } else if (state is PromptLoaded) {
          // No images found, show error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('No images found. Please try a different search term.'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appTitle),
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/img.png',
                            height: 200,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.enterTheme,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.enterTheme,
                            prefixIcon: const Icon(Icons.search),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppLocalizations.of(context)!.enterTheme;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<PromptCubit, PromptState>(
                          builder: (context, state) {
                            return PrimaryButton(
                              onPressed:
                                  state is PromptLoading ? () {} : _startGame,
                              label: AppLocalizations.of(context)!.startGame,
                              icon: Icons.play_arrow,
                              isLoading: state is PromptLoading,
                              isActive: state.isOnline,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(AppLocalizations.of(context)!.or),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _startOfflineGame,
                          child:
                              Text(AppLocalizations.of(context)!.playOffline),
                        ),
                        const Spacer(),
                        const SizedBox(height: 20),
                        Text(
                          'Powered by Pixabay',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                      ],
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
