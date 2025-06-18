/// 윈도우 상태를 나타내는 엔티티
class WindowEntity {
  final bool isVisible;
  final bool isFocused;
  final bool isMinimized;
  final double width;
  final double height;
  final double x;
  final double y;
  
  const WindowEntity({
    required this.isVisible,
    required this.isFocused,
    required this.isMinimized,
    required this.width,
    required this.height,
    required this.x,
    required this.y,
  });
  
  WindowEntity copyWith({
    bool? isVisible,
    bool? isFocused,
    bool? isMinimized,
    double? width,
    double? height,
    double? x,
    double? y,
  }) {
    return WindowEntity(
      isVisible: isVisible ?? this.isVisible,
      isFocused: isFocused ?? this.isFocused,
      isMinimized: isMinimized ?? this.isMinimized,
      width: width ?? this.width,
      height: height ?? this.height,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WindowEntity &&
          runtimeType == other.runtimeType &&
          isVisible == other.isVisible &&
          isFocused == other.isFocused &&
          isMinimized == other.isMinimized &&
          width == other.width &&
          height == other.height &&
          x == other.x &&
          y == other.y;
  
  @override
  int get hashCode =>
      isVisible.hashCode ^
      isFocused.hashCode ^
      isMinimized.hashCode ^
      width.hashCode ^
      height.hashCode ^
      x.hashCode ^
      y.hashCode;
  
  @override
  String toString() {
    return 'WindowEntity{isVisible: $isVisible, isFocused: $isFocused, isMinimized: $isMinimized, width: $width, height: $height, x: $x, y: $y}';
  }
}
