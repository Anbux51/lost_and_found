enum ItemType {
  lost('lost', 'Lost'),
  found('found', 'Found');

  const ItemType(this.value, this.label);

  final String value;
  final String label;

  static ItemType? tryFrom(String? value) {
    for (final type in values) {
      if (type.value == value) return type;
    }
    return null;
  }
}