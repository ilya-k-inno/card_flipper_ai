class CardModel {
  final String id;
  final String value;
  final String? imageUrl;
  final bool isFaceUp;
  final bool isMatched;

  bool get isImageCard => imageUrl != null;

  const CardModel({
    required this.id,
    required this.value,
    this.imageUrl,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  CardModel copyWith({
    String? id,
    String? value,
    String? imageUrl,
    bool? isFaceUp,
    bool? isMatched,
  }) {
    return CardModel(
      id: id ?? this.id,
      value: value ?? this.value,
      imageUrl: imageUrl ?? this.imageUrl,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
