enum ClaimStatus {
  pending('pending', 'Pending'),
  approved('approved', 'Approved'),
  rejected('rejected', 'Rejected');

  const ClaimStatus(this.value, this.label);

  final String value;
  final String label;

  static ClaimStatus? tryFrom(String? value) {
    for (final status in values) {
      if (status.value == value) return status;
    }
    return null;
  }
}