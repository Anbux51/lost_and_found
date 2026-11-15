enum UserRole {
  student('student', 'Student'),
  staff('staff', 'Staff'),
  admin('admin', 'Administrator');

  const UserRole(this.value, this.label);

  final String value;
  final String label;

  bool get isAdmin => this == UserRole.admin;

  static UserRole? tryFrom(String? value) {
    for (final role in values) {
      if (role.value == value) return role;
    }
    return null;
  }
}