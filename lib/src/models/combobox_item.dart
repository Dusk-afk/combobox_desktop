class ComboboxItem<T> {
  final T value;

  const ComboboxItem({
    required this.value,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComboboxItem<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
