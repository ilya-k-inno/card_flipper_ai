import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_flip/l10n/app_localizations.dart';
import 'package:pixel_flip/src/core/utils/haptic_feedback_utils.dart';
import 'package:pixel_flip/src/features/game/presentation/game/bloc/game_cubit.dart';
import 'package:pixel_flip/src/features/game/presentation/game/widgets/memory_card.dart';

class GameScreen extends StatefulWidget {
  final List<String>? imageUrls;
  final bool isOfflineMode;
  final String? prompt;

  const GameScreen({
    super.key,
    this.imageUrls,
    this.isOfflineMode = false,
    this.prompt,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameCubit _gameCubit;

  @override
  void initState() {
    super.initState();
    _gameCubit = GameCubit();

    // Initialize game with the provided images or in offline mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameCubit.initializeGame(
        widget.imageUrls,
        isOfflineMode: widget.isOfflineMode,
      );

      // Preload images if any
      if (widget.imageUrls != null) {
        _preloadImages(widget.imageUrls!);
      }
    });
  }

  Future<void> _preloadImages(List<String> urls) async {
    for (final url in urls) {
      if (mounted && context.mounted) {
        try {
          // This will cache the image
          await precacheImage(NetworkImage(url), context);
        } catch (e) {
          debugPrint('Failed to preload image: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _gameCubit.close();
    super.dispose();
  }

  Future<void> _showGameOverDialog(int moves) async {
    HapticUtils.success();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          // Handle back button press
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        child: AlertDialog(
          title: Text(AppLocalizations.of(context)!.gameOver),
          content: Text(AppLocalizations.of(context)!.youWon(moves.toString())),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _gameCubit.resetGame();
              },
              child: Text(AppLocalizations.of(context)!.playAgain),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.backToHome),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      bloc: _gameCubit,
      listener: (context, state) {
        if (state is GameWon) {
          _showGameOverDialog(state.moves);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await HapticUtils.selectionClick();
              if (mounted && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: BlocBuilder<GameCubit, GameState>(
            bloc: _gameCubit,
            builder: (context, state) {
              if (state is GameInProgress) {
                return Text(AppLocalizations.of(context)!
                    .moves(state.moves.toString()));
              }
              return Text(
                AppLocalizations.of(context)!.appTitle,
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await HapticUtils.selectionClick();
                if (mounted && context.mounted) {
                  await Navigator.pushNamed(context, '/settings');
                  if (mounted) {
                    setState(() {});
                  }
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<GameCubit, GameState>(
          bloc: _gameCubit,
          builder: (context, state) {
            if (state is GameInitial || state is GameLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GameError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _gameCubit.resetGame(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (state is GameInProgress) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: state.cards.length,
                itemBuilder: (context, index) {
                  final card = state.cards[index];
                  return MemoryCard(
                    card: card,
                    onTap: () => _gameCubit.cardTapped(index),
                  );
                },
              );
            } else if (state is GameWon) {
              // The dialog is shown in the listener
              return const SizedBox.shrink();
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
