class ChangePasswordModel {
  final String senhaAntiga;
  final String senhaNova;

  ChangePasswordModel({
    required this.senhaAntiga,
    required this.senhaNova,
  });

  Map<String, dynamic> toJson() => {
        'senha_antiga': senhaAntiga,
        'senha_nova': senhaNova,
      };
}
