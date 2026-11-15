enum ItemStatus {
  open('open', 'Open'),
  underReview('under_review', 'Under Review'),
  claimed('claimed', 'Claimed'),
  returned('returned', 'Returned');

  const ItemStatus(this.value, this.label);

  final String value;
  final String label;

  static ItemStatus? tryFrom(String? value) {
    for (final status in values) {
      if (status.value == value) return status;
    }
    return null;
  }
}