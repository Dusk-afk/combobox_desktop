class ComboboxItem<T> {
  final T value;
  final bool disabled;

  const ComboboxItem({
    required this.value,
    this.disabled = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComboboxItem<T> &&
        other.value == value &&
        other.disabled == disabled;
  }

  @override
  int get hashCode => value.hashCode ^ disabled.hashCode;
}
