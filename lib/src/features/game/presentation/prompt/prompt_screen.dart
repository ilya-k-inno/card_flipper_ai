import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_flip/src/core/widgets/primary_button.dart';
import 'package:pixel_flip/src/features/game/presentation/game/game_screen.dart';
import 'package:pixel_flip/src/features/game/presentation/prompt/bloc/prompt_cubit.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/utils/haptic_feedback_utils.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: -0.16, // -15 degrees in radians
      end: 0.16, // 15 degrees in radians
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
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
                prompt: state.searchQuery,
              ),
            ),
          );
          // Clear the search field after successful navigation
          _searchController.clear();
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
              onPressed: () async {
                await HapticUtils.selectionClick();
                if (mounted) {
                  await Navigator.pushNamed(context, '/settings');
                  if (mounted) {
                    setState(() {});
                  }
                }
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
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: Transform.scale(
                                scale: _scaleAnimation.value,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    'assets/images/img.png',
                                    height: 200,
                                  ),
                                ),
                              ),
                            );
                          },
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
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
                            return Column(
                              spacing: 16,
                              children: [
                                // Start Game Button
                                PrimaryButton(
                                  onPressed: state is PromptLoading
                                      ? () {}
                                      : _startGame,
                                  label: state is PromptLoading
                                      ? AppLocalizations.of(context)!
                                          .searchingImages
                                      : AppLocalizations.of(context)!.startGame,
                                  icon: Icons.play_arrow,
                                  isLoading: state is PromptLoading,
                                  isActive:
                                      state.isOnline && state is! PromptLoading,
                                ),

                                // Play Last Game Button (only shown if there's a cached game)
                                if (state.cachedGame != null) ...[
                                  PrimaryButton(
                                    onPressed: state is PromptLoading
                                        ? () {}
                                        : () => context
                                            .read<PromptCubit>()
                                            .playCachedGame(),
                                    label:
                                        '${AppLocalizations.of(context)!.playLast} ${state.cachedGame?.prompt ?? ''}',
                                    icon: Icons.replay,
                                    isActive: state is! PromptLoading,
                                  ),
                                ],
                                Text(AppLocalizations.of(context)!.or),
                                OutlinedButton(
                                  onPressed: state is PromptLoading
                                      ? null
                                      : () async {
                                          await HapticUtils.buttonPress();
                                          _startOfflineGame();
                                        },
                                  child: Text(AppLocalizations.of(context)!
                                      .playOffline),
                                ),
                              ],
                            );
                          },
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
    _controller.dispose();
    super.dispose();
  }
}
