/// Entidade pura de domínio representando o professor/usuário autenticado.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.createdAt,
  });

  final String id;
  final String email;
  final DateTime? createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => Object.hash(id, email);
}

