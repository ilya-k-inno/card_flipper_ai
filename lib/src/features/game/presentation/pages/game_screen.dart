import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_flip/src/features/game/presentation/bloc/game_cubit.dart';
import 'package:pixel_flip/src/features/game/presentation/widgets/memory_card.dart';

class GameScreen extends StatefulWidget {
  final List<String>? imageUrls;
  final bool isOfflineMode;

  const GameScreen({
    super.key,
    this.imageUrls,
    this.isOfflineMode = false,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameCubit _gameCubit;

  @override
  void initState() {
    super.initState();
    _gameCubit = GameCubit()..initializeGame(
      widget.imageUrls,
      isOfflineMode: widget.isOfflineMode,
    );
  }

  @override
  void dispose() {
    _gameCubit.close();
    super.dispose();
  }

  void _showGameOverDialog(int moves) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You won in $moves moves!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _gameCubit.resetGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Back to Home'),
          ),
        ],
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
          title: BlocBuilder<GameCubit, GameState>(
            bloc: _gameCubit,
            builder: (context, state) {
              if (state is GameInProgress) {
                return Text('Moves: ${state.moves}');
              }
              return const Text('Pixel Flip');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _gameCubit.resetGame(),
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
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
