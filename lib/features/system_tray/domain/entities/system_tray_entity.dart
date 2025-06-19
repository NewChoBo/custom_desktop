/// 트레이 메뉴 아이템 엔티티
class SystemTrayMenuEntity {
  final String key;
  final String label;
  final bool isSeparator;

  const SystemTrayMenuEntity({
    required this.key,
    required this.label,
    this.isSeparator = false,
  });

  const SystemTrayMenuEntity.separator()
    : key = '',
      label = '',
      isSeparator = true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemTrayMenuEntity &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          label == other.label &&
          isSeparator == other.isSeparator;

  @override
  int get hashCode => key.hashCode ^ label.hashCode ^ isSeparator.hashCode;

  @override
  String toString() {
    return 'SystemTrayMenuEntity{key: $key, label: $label, isSeparator: $isSeparator}';
  }
}
