import 'package:flutter/material.dart';
import 'package:pixel_flip/src/features/game/domain/entities/card_model.dart';

class MemoryCard extends StatefulWidget {
  final CardModel card;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> with TickerProviderStateMixin {
  static const Duration flipDuration = Duration(milliseconds: 300);
  static const Duration matchAnimationDuration = Duration(milliseconds: 300);

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _matchController;
  late Animation<double> _matchAnimation;
  bool _isFront = false;

  @override
  void initState() {
    super.initState();

    // Flip animation controller
    _flipController = AnimationController(
      vsync: this,
      duration: flipDuration,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );

    // Match animation controller with faster animation
    _matchController = AnimationController(
      vsync: this,
      duration: matchAnimationDuration,
    );

    _matchAnimation = CurvedAnimation(
      parent: _matchController,
      curve: Curves.easeInQuad, // Slightly snappier curve
    );

    // Start match animation when card becomes matched
    if (widget.card.isMatched) {
      _matchController.forward();
    }
  }

  @override
  void didUpdateWidget(MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle flip state changes
    if (widget.card.isFaceUp != oldWidget.card.isFaceUp) {
      _toggleCard();
    }

    // Handle match state changes
    if (widget.card.isMatched != oldWidget.card.isMatched) {
      if (widget.card.isMatched) {
        _matchController.forward();
      } else {
        _matchController.reverse();
      }
    }
  }

  void _toggleCard() {
    if (_isFront != widget.card.isFaceUp) {
      _isFront = widget.card.isFaceUp;
      if (mounted) {
        if (_isFront) {
          _flipController.forward();
        } else {
          _flipController.reverse();
        }
      }
    }
  }

  @override
  void dispose() {
    _flipController.stop();
    _matchController.stop();
    _flipController.dispose();
    _matchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.card.isMatched ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * 3.14159;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          final isFront = _flipAnimation.value > 0.5;

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isFront ? _buildFront() : _buildBack(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    final content = widget.card.isImageCard
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.card.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 40),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        : Center(
            child: Transform(
              transform: Matrix4.identity()
                ..rotateY(3.14159), // 180 degrees in radians
              alignment: Alignment.center,
              child: Text(
                widget.card.value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );

    final checkmark = Container(
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _matchAnimation,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Card content
            Opacity(
              opacity: 1 - _matchAnimation.value,
              child: content,
            ),
            // Checkmark overlay
            Positioned.fill(
              child: Opacity(
                opacity: _matchAnimation.value,
                child: checkmark,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.indigo],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.help_outline,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
